module LeafletsHelper

  def render_leaflet_option room, story
    # 
    user_story_points = room.leaflet_options(current_user.id)
    # binding.pry
    room.point_values.inject(''.html_safe) do |html, value|
      html + content_tag(:li) do
        btn_class = if user_story_points[story.id] == value
          "btn btn-info"
        else
          "btn btn-default"
        end

        tag(:input, class: btn_class, type: 'button', value: value)
      end
    end
  end

end
