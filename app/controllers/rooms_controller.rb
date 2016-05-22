class RoomsController < ApplicationController

  include ApplicationHelper

  before_action :set_room, only: [:show, :edit, :update, :destroy, :vote, :story_list, :user_list]
  before_action :validate_user

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
      user.points = user.points_of_story cookies[:story_id]
    end if params[:sync] == 'true'
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
      if @room.update(room_params)
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

  def set_user_name
    if request.post?
      user = User.find_or_initialize_by name: params[:name]
      if user.save
        cookies[:user_id] = user.id
        redirect_to params[:redirect] || '/'
      else
        redirect_to :back, message: 'User name has been taken'
      end
    end
  end

  def set_story_point
    if current_user.owner?
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
        stories_attributes: [:link, :desc]
      )
    end

    def validate_user
      cookies[:room_id] = params[:id]
      if current_user.blank?
        redirect_to "#{new_user_session_path}?redirect=#{request.path}" and return
      else
        user_room_story = UserRoom.find_or_initialize_by user_id: current_user.id, room_id: params[:id]
        user_room_story.save
        set_user_role
      end
    end

    def set_user_role
      if current_user.role.blank?
        if @room.users.blank?
          # if first user come into the room
          # then he/she is the owner
          current_user.role = 0
        else
          current_user.role = 1
        end
        current_user.save!
      end
    end
end
