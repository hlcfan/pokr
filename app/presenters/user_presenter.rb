class UserPresenter < SimpleDelegator

  PER_PAGE = 10

  def participated_rooms page=1
    @participated_rooms ||= begin
      if page < 1
        []
      else
        rooms.offset((page-1)*PER_PAGE).order("created_at DESC").limit(PER_PAGE).to_a
      end
    end
  end

  def timestamp_for_line_chart
    Rails.cache.fetch "#{id}:timeline" do
      rooms_for_chart.map do |created_at, _|
        created_at.strftime("%b %d")
      end
    end
  end

  def story_size_for_line_chart
    Rails.cache.fetch "#{id}:storysize" do
      rooms_for_chart.map do |_, size|
        size
      end
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
      rooms_for_chart.inject(0) do |total, (_, _, duration)|
        total + (duration || 0)
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

  private

  def rooms_for_chart
    rooms.pluck(:created_at, :stories_count, :duration)
  end

end