class UserPresenter

  attr_accessor :user

  def initialize user
    @user = user
  end

  def created_rooms
    participated_room.select do |room|
      user.id == room.created_by
    end
  end

  def participated_room
    @participated_room ||= user.rooms.order("created_at DESC").to_a
  end

  def recent_rooms
    participated_room.take(3).select do |room|
      room.status == Room::DRAW
    end
  end

  def timestamp_for_line_chart
    participated_room.reverse.map do |room|
      room.created_at.strftime("%b %d")
    end
  end

  def story_size_for_line_chart
    participated_room.reverse.map do |room|
      room.stories.size
    end
  end

end