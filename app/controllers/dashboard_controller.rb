class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
    @created_rooms = current_user.created_rooms.order("created_at DESC")
    @partipated_rooms = current_user.rooms.order("created_at DESC")
    
  end

end
