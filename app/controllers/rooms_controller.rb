class RoomsController < ApplicationController

  include RoomsHelper

  before_action :authenticate_user!
  before_action :set_room, only: [:show, :edit, :update, :destroy, :vote, :story_list, :user_list, :set_story_point, :set_room_status, :draw_board]
  before_action :enter_room, only: [:show]

  def index
    @rooms = Room.all
  end

  def show
  end

  def vote
    if valid_vote?
      UserStoryPoint.vote(current_user.id,
                      params[:story_id],
                      params[:points]) do |user_story_point|
        broadcast_user_point user_story_point
      end
    else
      head :bad_request
    end
  end

  def set_room_status
    if valid_room_status.present? && (@room.status != valid_room_status)
      @room.update_attribute :status, valid_room_status
    end
    head :no_content
  end

  def broadcast_user_point user_point
    ActionCable.server.broadcast "rooms/#{@room.slug}",
        person_id: user_point.user_id,
        story_id: user_point.story_id,
        points: user_point.points
    head :no_content
  end

  def story_list
    @stories = @room.un_groomed_stories
  end

  def user_list
    @users = @room.users.to_a
    @users.each do |user|
      user_point = user.points_of_story(@room.current_story_id)
      user.display_role = UserRoom.find_by_with_cache(user_id: user.id, room_id: @room.id).display_role
      user.points = user_point if params[:sync] == 'true'
      user.voted = !!user_point
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @room.pv = @room.point_values.join(',')
    @room.stories.build
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    if 'true' == params[:bulk]
      params[:room][:stories_attributes] = bulk_import_params
    end

    @room = Room.new(room_params.merge(created_by: current_user.id))

    respond_to do |format|
      if @room.save
        set_user_room_moderator
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
      if @room.update_attributes(room_params)
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

  def set_story_point
    user_room = UserRoom.find_by_with_cache(user_id: current_user.id, room_id: @room.id)

    if user_room.moderator? && @room.valid_vote_point?(params[:point])
      story = Story.find_by id: params[:story_id], room_id: @room.id
      if story
        story.update_attribute :point, params[:point]
        @room.update_attribute :status, nil
      end
    end

    render json: { success: true }
  end

  def draw_board
    @stories = @room.groomed_stories
  end

  private

  def set_room
    @room = Room.find_by(slug: params[:id])
    raise ActiveRecord::RecordNotFound if @room.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def room_params
    params.require(:room).permit(
      :name, :pv,
      stories_attributes: [:id, :link, :desc, :_destroy]
    )
  end

  def set_user_room_moderator
    user_room = UserRoom.find_or_initialize_by(user_id: current_user.id, room_id: @room.id)
    user_room.role = UserRoom::MODERATOR
    user_room.save!
  end

  def enter_room
    user_room = UserRoom.find_or_initialize_by(user_id: current_user.id, room_id: @room.id)
    if user_room.new_record?
      user_room.role = UserRoom::PARTICIPANT
      user_room.save!
    end

    ActionCable.server.broadcast "rooms/#{@room.slug}",
        user_id: current_user.id,
        data: 'refresh-users',
        type: 'action'
  end

  def bulk_import_params
    links = params[:bulk_links].split "\r\n"
    return {} if links.blank?

    stories_hash = {}
    links.each_with_index do |story_link, index|
      stories_hash[index.to_s] = { link: story_link, desc: '', id: '', _destroy: "false" }
    end

    stories_hash
  end

  def valid_room_status
    {
      'open' => Room::OPEN,
      'draw' => Room::DRAW
    }[params[:status]]
  end

  def valid_vote?
    @room.valid_vote_point?(params[:points]) && params[:story_id].present?
  end

end
