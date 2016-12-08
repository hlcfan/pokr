class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
    @created_rooms = current_user.created_rooms.order("created_at DESC")
    @partipated_rooms = current_user.rooms.order("created_at DESC")
    room_ids = @partipated_rooms.where(status: Room::DRAW).map(&:id)
    @stories = Story.where(room_id: room_ids).limit(10)
  end

end
