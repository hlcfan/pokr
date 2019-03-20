class RoomsChannel < ApplicationCable::Channel

  def subscribed
    stream_from "rooms/#{params[:room]}"
  end

  [:action, :vote, :set_story_point, :remove_person, :timing, :revote, :clear_votes].each do |method_name|
    define_method method_name do |data|
      room = set_room data["roomId"]
      message = RoomCommunication.send(method_name, room, current_user, data)
      # binding.pry
      broadcast "rooms/#{room.slug}", message
    end
  end

  private

  def set_room room_id
    # TODO: find from cache
    # @room = Room.find_by slug: room_id
    Room.find_by slug: room_id
  end

  def broadcast channel, *message
    # binding.pry# if message[:data].blank? || message["data"].blank?
    return if message[0].blank?
    ActionCable.server.broadcast channel, *message
  end

end
