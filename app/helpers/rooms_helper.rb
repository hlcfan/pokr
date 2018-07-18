module RoomsHelper

  def state_class room
    if room.status == Room::DRAW
      "label-default"
    else
      "label-info"
    end
  end

  def render_point_values new_record, numbers, room_points
    numbers.inject(''.html_safe) do |html, value|
      html + content_tag(:li) do
        btn_class = if new_record || room_points.include?(value)
          "btn btn-info"
        else
          "btn btn-default"
        end

        tag(:input, class: btn_class, type: 'button', value: value)
      end
    end
  end

  def component_name
    component_name = if is_mobile_request?
      "RoomMobile"
    else
      "Room"
    end
  end

  def my_point_schemes
    Scheme.default_schemes.merge Scheme.schemes_of(current_user.id)
  end

end
