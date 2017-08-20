class UserPresenter < SimpleDelegator

  PER_PAGE = 5

  # def created_rooms page=1
  #   participated_rooms(page).select do |room|
  #     id == room.created_by
  #   end
  # end

  def participated_rooms page=1
    @participated_rooms ||= rooms.offset(page-1).order("created_at DESC").limit(PER_PAGE).to_a
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
    # TODO: optimize it
    # Push mode: implement a worker to pre-pop the cache?
    Story.joins(:user_story_points)
      .where("user_story_points.user_id = ?", id)
      .where("point IS NOT NULL")
      .order("updated_at DESC").limit(10)
  end


  def time_spent
    @time_spent ||= begin
      participated_rooms.inject(0) do |total, room|
        total + room.time_duration
      end
    end
  end

  def skip_rate
    # TODO: same as #recent_stories
    points_array = Story.joins(:user_story_points)
      .where("user_story_points.user_id = ?", id)
      .where("point IS NOT NULL").pluck(:point)
    if points_array.size > 0
      skipped_count = points_array.count { |point| point == "null" }
      (skipped_count / points_array.size.to_f).round(2)*100
    else
      0
    end
  end

  def avg_per_story
    if stories_groomed_count > 0
      (time_spent/stories_groomed_count).round(2)
    else
      0
    end
  end

end