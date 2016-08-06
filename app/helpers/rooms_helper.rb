module RoomsHelper

  def state_class room
    if room.status == Room::DRAW
      "label-default"
    else
      "label-success"
    end
  end

  def generate_point_values point_values
    Room::DEFAULT_POINT_VALUES.inject(''.html_safe) do |html, value|
      html + content_tag(:li) do
        btn_class = point_values.include?(value) ? "btn btn-info" : "btn btn-default"

        tag(:input, class: btn_class, type: 'button', value: value)
      end
    end
  end

end
