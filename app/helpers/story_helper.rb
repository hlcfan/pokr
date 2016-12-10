module StoryHelper

  def symbol_point_hash point
    {
      "coffee" => "☕",
      "?"      => "⁉️",
      "null"   => "skipped"
    }[point] || point
  end

end