class RoomsController < ApplicationController

  before_action :redirect_to_screen, only: [:show]
  before_action :authenticate_user!, except: [:screen]
  before_action :set_room, only: [:show, :edit, :update, :destroy, :story_list, :user_list, :set_room_status, :draw_board, :switch_role, :summary, :invite, :timing]
  before_action :enter_room, only: [:show]

  def index
    redirect_to dashboard_index_path
  end

  def set_room_status
    if valid_room_status.present? && (@room.status != valid_room_status)
      @room.update_attribute :status, valid_room_status
    end
    head :no_content
  end

  def story_list
    @stories = @room.grouped_stories
  end

  def user_list
    @users = @room.user_list params
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    cookies[:room_id] = @room.slug
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @room.stories.build
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = repo.new_entity(room_params.merge(created_by: current_user.id))
    respond_to do |format|
      if repo.save @room
        format.html { redirect_to room_path(@room.slug), notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if repo.update_entity @room, room_params
        format.html { redirect_to room_path(@room.slug), notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def summary
    @summaries = @room.summary
  end

  def draw_board
    @stories = @room.groomed_stories
  end

  def switch_role
    role = params[:role].to_i
    unless [UserRoom::PARTICIPANT, UserRoom::WATCHER].include? role
      head :bad_request and return
    end

    user_room = UserRoom.find_by_with_cache(user_id: current_user.id, room_id: @room.id)
    if user_room && !user_room.moderator? && user_room.role != role
      user_room.update(role: role)
      broadcaster "rooms/#{@room.slug}",
        user_id: current_user.id,
        data: 'switch-roles',
        type: 'action'
      head :ok
    else
      head :bad_request
    end
  end

  def invite
    emails = params[:emails].select { |email| email =~ User::VALID_EMAIL_REGEX }
    emails.each do |email_address|
      RoomInvitationMailer.invite(
        from_email: current_user.email, 
        from_name: current_user.display_name,
        to: email_address,
        room_name: @room.name,
        room_slug: @room.slug
      ).deliver_later
    end

    head :ok
  end

  def timing
    @room.update_duration params[:duration].to_f

    head :ok
  end

  def screen
    if signed_in?
      redirect_to room_path(params[:id])
    end
    if request.post?
      current_or_guest_user
      redirect_to room_path(params[:id])
    end
  end

  private

  def set_room
    @room = Room.find_by(slug: params[:id])
    raise ActiveRecord::RecordNotFound if @room.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def room_params
    params.require(:room).permit(
      :name, :pv, :timer, :style, :bulk, :bulk_links, :moderator_ids,
      :scheme,
      stories_attributes: [:id, :link, :desc, :_destroy]
    )
  end

  def repo
    @repo ||= RoomRepository.new
  end

  def enter_room
    user_room = UserRoom.find_or_initialize_by(user_id: current_user.id, room_id: @room.id)
    if user_room.new_record?
      user_room.update!(role: UserRoom::PARTICIPANT)
      broadcaster "rooms/#{@room.slug}",
        user_id: current_user.id,
        data: 'refresh-users',
        type: 'action'
    end
  end

  def valid_room_status
    {
      'open' => Room::OPEN,
      'draw' => Room::DRAW
    }[params[:status]]
  end

  def broadcaster channel, *message
    ActionCable.server.broadcast channel, *message
  end

  def redirect_to_screen
    if current_user.nil?
      redirect_to screen_room_path(params[:id])
    end    
  end

end
