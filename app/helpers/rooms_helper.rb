module RoomsHelper

  def broadcast(channel, message)
    faye_client.publish channel, message
  end


  def story_id room_story_id
    room_story_id.split('/')[1]
  end

  def state_class room
    if room.status == Room::DRAW
      "label-default"
    else
      "label-success"
    end
  end

  private

  def faye_client
    @faye_client ||= Faye::Client.new(Rails.configuration.faye_server)
  end

end
