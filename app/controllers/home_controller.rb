class HomeController < ApplicationController

  def index
    redirect_to dashboard_index_path and return if current_user
    render layout: false
  end

  def director
    room = Room.find_by(slug: params[:name])
    if room.present?
      redirect_to room_path(room)
    else
      redirect_to new_room_path
    end
  end

end
