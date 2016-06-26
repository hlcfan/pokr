module RoomsHelper

  def broadcast(channel, message)
    faye_client.publish channel, message
  end


  def story_id room_story_id
    room_story_id.split('/')[1]
  end

  private

  def faye_client
    @faye_client ||= Faye::Client.new(Rails.configuration.faye_server)
  end

end
