class RoomsController < ApplicationController

  include Premium

  before_action :guest_check, only: [:show, :leaflet_view]
  before_action :authenticate_user!, except: [:screen]
  before_action :set_room, only: [:show, :edit, :update, :destroy, :story_list, :user_list, :set_room_status, :draw_board, :switch_role, :summary, :invite, :sync_status, :leaflet_submit, :leaflet_view, :leaflet_finalize_point]
  before_action :enter_room, only: [:show]
  protect_from_forgery except: :sync_status, unless: -> { request.format.json? }

  def index
    redirect_to dashboard_index_path
  end

  def set_room_status
    if valid_room_status.present? && (@room.status != valid_room_status)
      @room.update_attribute :status, valid_room_status
    end

    respond_to do |format|
      format.json { head :no_content }
      format.js
    end
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
    if moderator_of_async_room? && html_request?
      redirect_to(view_room_path(@room.slug)) and return
    end

    cookies[:room_id] = @room.slug
    respond_to do |format|
      format.html { render "#{room_template_path}/show" }
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=#{excel_filename}.xlsx"
      }
    end
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
    if @room.async_mode?
      premium_check(billing_path, "Only premium user can create async rooms, be our premium member.", !current_user.premium?); return if performed?
    end
    respond_to do |format|
      if repo.save @room
        remove_memorization_of_moderators
        format.html { redirect_to room_path(@room.slug), notice: "Room was successfully created." }
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
        remove_memorization_of_moderators
        broadcaster "rooms/#{@room.slug}",
          user_id: current_user.id,
          data: 'next-story',
          type: 'action'
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
    head :bad_request and return if @room.created_by != current_user.id
    @room.soft_delete
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
      format.js
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

  def screen
    if current_user
      redirect_to room_path(params[:id]) and return
    end

    handle_quick_join
  end

  def sync_status
    broadcaster "rooms/#{@room.slug}",
      type: 'sync',
      data: {link: params[:link], point: params[:point]}

    head :ok
  end

  def leaflet_submit
    head(:bad_request) and return if params[:votes].blank? || @room.closed?

    params[:votes].values.each do |vote|
      next unless @room.stories.pluck(:id).include?(vote[:story_id].to_i)
      UserStoryPoint.vote(current_user.id, vote[:story_id], vote[:point], vote[:comment])
    end
    redirect_to room_path(@room.slug), flash: { success: "Thanks for your votes, moderator will see your votes!" }
  end

  def leaflet_view
    redirect_to room_path(@room.slug) and return if @room.created_by != current_user.id
    @story_points = @room.leaflet_votes_summary

    render "rooms/leaflets/view"
  end

  def leaflet_finalize_point
    user_story_point = UserStoryPoint.find UserStoryPoint.decoded_id(params[:voteId])
    user_room = UserRoom.find_by_with_cache(user_id: current_user.id, room_id: @room.id)

    if user_story_point.present? && user_room.moderator? && @room.valid_vote_point?(user_story_point.points)
      story = Story.find_by id: user_story_point.story_id, room_id: @room.id
      story.update_attribute :point, user_story_point.points if story
      UserStoryPoint.where(story_id: story.id).where.not(finalized: nil).update_all(finalized: nil)
      user_story_point.update_attribute(:finalized, true)

      head :ok
    end
  end

  private

  def html_request?
    request.format != "xlsx"
  end

  def moderator_of_async_room?
    @room.async_mode? && UserRoom.find_by_with_cache(user_id: current_user.id, room_id: @room.id).moderator?
  end

  def room_template_path
    if @room.style == Room::LEAFLET_STYLE
      "rooms/leaflets"
    else
      "rooms"
    end
  end

  def excel_filename
    @room.slug[0..29]
  end

  def remove_memorization_of_moderators
    cookies.delete :moderators
  end

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
    redirection_path = signed_in? ? dashboard_index_path : screen_room_path(@room.slug)
    user_room = UserRoom.find_or_initialize_by(user_id: current_user.id, room_id: @room.id)
    premium_check(redirection_path, "Non-premium moderator can only create room with 10 participants at most, please tell your moderator to be our premium member.", !@room.creator.premium?, @room.created_by != current_user.id, @room.users.count > 9, user_room.new_record?); return if performed?

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

  def guest_check
    if current_user.nil?
      redirect_to screen_room_path(params[:id])
    end
  end

  def handle_quick_join
    if request.post?
      if params[:username] =~ User::VALID_EMAIL_REGEX && User.exists?(email: params[:username].downcase)
        redirect_to new_user_session_path, flash: { success: "Your're already signed up, please sign in" }
        return
      else
        current_or_guest_user
        redirect_to room_path(params[:id]) and return
      end
    end
  end

end
