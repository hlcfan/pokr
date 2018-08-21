module LeafletsHelper

  def render_point_options numbers
    numbers.inject(''.html_safe) do |html, value|
      html + content_tag(:li) do
        tag(:input, class: "btn btn-default", type: 'button', value: value)
      end
    end
  end

end
