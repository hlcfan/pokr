class RoomsChannel < ApplicationCable::Channel  

  def subscribed
    # called every time a
    # client-side subscription is initiated
    stream_from "rooms/#{params[:room]}"
  end

  def room_action data
    ActionCable.server.broadcast "rooms/#{data['roomId']}", data
  end

  def vote data
    payload = data["data"]
    room_id = data["roomId"]
    @room = Room.find_by slug: room_id
    if valid_vote? payload
      UserStoryPoint.vote(current_user.id,
                      payload["story_id"],
                      payload["points"]) do |user_story_point|
        broadcaster "rooms/#{@room.slug}",
                    type: "notify",
                    person_id: user_story_point.user_id,
                    story_id: user_story_point.story_id,
                    points: user_story_point.points
      end
    end
  end

  private

  def valid_vote? payload
    @room.valid_vote_point?(payload["points"]) && payload["story_id"].present?
  end

  def broadcaster channel, *message
    ActionCable.server.broadcast channel, *message
  end

end  