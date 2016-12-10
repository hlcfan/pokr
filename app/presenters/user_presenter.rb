class UserPresenter < SimpleDelegator

  def created_rooms
    participated_rooms.select do |room|
      id == room.created_by
    end
  end

  def participated_rooms
    @participated_rooms ||= rooms.order("created_at DESC").to_a
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


  def time_spent
    @time_spent ||= begin
      participated_rooms.inject(0) do |total, room|
        total += (room.time_duration || 0)
      end
    end
  end

end