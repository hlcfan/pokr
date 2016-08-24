class RoomsChannel < ApplicationCable::Channel  

  def subscribed
    # called every time a
    # client-side subscription is initiated
    stream_from "rooms/#{current_room_id}"
  end

  def room_action data
    ActionCable.server.broadcast "rooms/#{data['roomId']}", data
  end

end  