module ApplicationHelper

  def broadcast(channel, message)
    envelope = {:channel => channel, :data => message, :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => envelope.to_json)
  end

end
