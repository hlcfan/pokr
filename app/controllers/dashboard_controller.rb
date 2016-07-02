class DashboardController < ApplicationController

  def index
    @created_rooms = current_user.created_rooms
    @partipated_rooms = current_user.rooms
  end

end
