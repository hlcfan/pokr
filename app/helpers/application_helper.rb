module ApplicationHelper

  def title(title)
    content_for(:title, title)
  end

  def description description
    description = truncate description, length: 160, seperator: ' '
    content_for :description_meta_content, description
  end

  def default_description
    "Pokr, is an efficiency pointing poker or planning poker aim for improving the efficiency and user experience of agile teams"
  end

  def flash_messages opts = {}
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    end
    nil
  end

  private

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

end
