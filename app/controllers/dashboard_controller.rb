class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
    user = UserPresenter.new(current_user)
    @created_rooms = user.created_rooms
    @partipated_rooms = user.participated_room
    room_ids = user.recent_rooms.map(&:id)
    @stories = Story.where(room_id: room_ids).limit(10)
  end

end
