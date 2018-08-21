class LeafletsController < ApplicationController

  before_action :guest_check, only: [:show]
  before_action :authenticate_user!, except: [:screen]
  before_action :set_room, only: [:show, :edit, :update, :destroy, :story_list, :user_list, :set_room_status, :draw_board, :switch_role, :summary, :invite, :sync_status]
  before_action :enter_room, only: [:show]
  protect_from_forgery except: :sync_status

  def new
    @leaflet = Room.new
    @leaflet.stories.build
  end

  def create
    @leaflet = repo.new_entity(leaflet_params.merge(created_by: current_user.id))
    respond_to do |format|
      if repo.save @leaflet
        format.html { redirect_to leaflet_path(@leaflet.slug), notice: "Leaflet was successfully created." }
        format.json { render :show, status: :created, location: @leaflet }
      else
        format.html { render :new }
        format.json { render json: @leaflet.errors, status: :unprocessable_entity }
      end
    end
  end

  def show

  end

  private

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


  def set_room
    @room = Room.find_by(slug: params[:id])
    raise ActiveRecord::RecordNotFound if @room.nil?
  end

  def guest_check
    if current_user.nil?
      redirect_to screen_room_path(params[:id])
    end
  end

  def repo
    @repo ||= RoomRepository.new
  end

  def leaflet_params
    params.require(:room).permit(
      :name, :pv, :bulk, :bulk_links, :scheme,
      stories_attributes: [:id, :link, :desc, :_destroy]
    )
  end
end
