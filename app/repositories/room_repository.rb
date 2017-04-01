class RoomRepository

  def new_entity params = {}
    Room.new params
  end

  def save room
    if room.save
      user_room_attrs = room.moderator.split(",").map do |moderator_id|
        { user_id: moderator_id, room_id: room.id, role: UserRoom::MODERATOR }
      end
      UserRoom.create user_room_attrs

      room
    end
  end

end