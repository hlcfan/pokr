class RoomsChannel < ApplicationCable::Channel  
  def follow data
    stream_from "rooms/#{data['room_id']}"
  end

  def room_action data
    ActionCable.server.broadcast "rooms/#{data['roomId']}", data
  end
end  