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
    Story.where.not(point: nil).order("updated_at DESC").limit(10)
  end

end