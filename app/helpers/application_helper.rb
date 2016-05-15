module ApplicationHelper

  def broadcast(channel, message)
    envelope = {:channel => channel, :data => message, :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => envelope.to_json)
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
