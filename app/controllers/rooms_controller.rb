class RoomsController < ApplicationController

  include ApplicationHelper

  before_action :authenticate_user!
  before_action :set_room, only: [:show, :edit, :update, :destroy, :vote, :story_list, :user_list]
  before_action :enter_room, only: [:show]

  def index
    @rooms = Room.all
  end

  def show
  end

  def vote
    points = params[:points].to_i
    # TODO: Need a valid vote list
    if points >= 0
      UserStoryPoint.vote(current_user.id,
                      params[:story_id],
                      points) do |user_story_point|
        broadcast_user_point user_story_point
      end

      render json: { success: true } and return
    end


    render json: { success: false }
  end

  def broadcast_user_point user_point
    broadcast "/rooms/#{@room.id}/#{user_point.story_id}",
              {person_id: user_point.user_id, story_id: user_point.story_id, points: user_point.points}
  end

  def story_list
    @stories = @room.un_groomed_stories
  end

  def user_list
    @users = @room.users.to_a
    @users.each do |user|
      user.display_role = UserRoom.find_by(room_id: @room.id, user_id: user.id).display_role
      user.points = user.points_of_story cookies[:story_id] if params[:sync] == 'true'
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
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
    @room = Room.new(room_params)
    respond_to do |format|
      if @room.save
        set_user_room_owner
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
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
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
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
    if current_user.user_room.owner?
      story = Story.find_by id: params[:story_id], room_id: params[:id]
      if story
        story.point = params[:point]
        story.save!
      end
    end

    render json: {success: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(
        :name,
        stories_attributes: [:id, :link, :desc, :_destroy]
      )
    end

    def set_user_room_owner
      user_room = UserRoom.find_or_initialize_by(user_id: current_user.id, room_id: @room.id)
      user_room.role = UserRoom::OWNER
      user_room.save!
    end

    def enter_room
      user_room = UserRoom.find_or_initialize_by(user_id: current_user.id, room_id: @room.id)
      if user_room.new_record?
        user_room.role = UserRoom::PARTICIPANT
        user_room.save!
      end
    end

end
