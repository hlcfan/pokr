class UserPresenter

  attr_accessor :user

  def initialize user
    @user = user
  end

  def created_rooms
    participated_rooms.select do |room|
      user.id == room.created_by
    end
  end

  def participated_rooms
    @participated_rooms ||= user.rooms.order("created_at DESC").to_a
  end

  def recent_rooms
    @recent_rooms ||= begin
      participated_rooms.take(3).select do |room|
        room.status == Room::DRAW
      end
    end
  end

  def timestamp_for_line_chart
    participated_rooms.reverse.map do |room|
      room.created_at.strftime("%b %d")
    end
  end

  def story_size_for_line_chart
    participated_rooms.reverse.map do |room|
      room.stories.size
    end
  end

  def recent_stories
    room_ids = recent_rooms.map(&:id)
    Story.where(room_id: room_ids).limit(10)
  end

end