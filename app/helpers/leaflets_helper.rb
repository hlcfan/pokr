module LeafletsHelper

  def render_leaflet_option current_vote, room, story
    room.point_values.inject(''.html_safe) do |html, value|
      html + content_tag(:li) do
        btn_class = if current_vote == value
          "btn btn-default btn-info"
        else
          "btn btn-default"
        end

        tag(:input, class: btn_class, type: 'button', value: value)
      end
    end
  end

end
