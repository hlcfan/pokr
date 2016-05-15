class HomeController < ApplicationController

  def index
    render layout: false
  end

  def director
    room = Room.find_by(name: params[:name])
    if room.present?
      redirect_to room_path(room)
    else
      redirect_to new_room_path
    end
  end

end
