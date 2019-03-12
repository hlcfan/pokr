class RoomsChannel < ApplicationCable::Channel  

  def subscribed
    stream_from "rooms/#{params[:room]}"
  end

  def action data
    if data["data"] == "open"
      set_room data["roomId"]
      @room.update_attribute(:status, Room::OPEN) if @room
    end
    ActionCable.server.broadcast "rooms/#{data['roomId']}", data
  end

  def vote data
    payload = data["data"]
    set_room data["roomId"]
    if valid_vote? payload
      UserStoryPoint.vote(current_user.id,
                      payload["story_id"],
                      payload["points"]) do |user_story_point|
        broadcaster "rooms/#{@room.slug}",
                    type: "notify",
                    person_id: user_story_point.user_id

                    # story_id: user_story_point.story_id,
                    # points: user_story_point.points,
                    # sync: @room.state == "open"
      end
    end
  end

  def set_story_point data
    payload = data["data"]
    set_room data["roomId"]

    user_room = UserRoom.find_by_with_cache(user_id: current_user.id, room_id: @room.id)

    if user_room.moderator? && @room.valid_vote_point?(payload["point"])
      story = Story.find_by id: payload["story_id"], room_id: @room.id
      if story
        story_point = @room.free_style? ? nil : payload["point"]
        story.update_attribute :point, story_point
        if @room.free_style?
          UserStoryPoint.where(story_id: story.id).destroy_all
        end
        @room.update_attribute :status, nil
        broadcaster "rooms/#{@room.slug}",
                    type: "action",
                    data: "next-story"
      end
    end
  end

  def revote data
    payload = data["data"]
    set_room data["roomId"]

    user_room = UserRoom.find_by_with_cache(user_id: current_user.id, room_id: @room.id)

    if user_room.moderator?
      story = Story.find_by id: payload["story_id"], room_id: @room.id
      if story
        story.update_attribute :point, nil
        @room.update_attribute :status, nil
        broadcaster "rooms/#{@room.slug}",
                    type: "action",
                    data: "revote"
      end
    end
  end

  def clear_votes data
    payload = data["data"]
    set_room data["roomId"]

    UserStoryPoint.where(story_id: payload["story_id"]).delete_all
    @room.update_attribute :status, nil
    broadcaster "rooms/#{data["roomId"]}",
            type: "action",
            data: "clear-votes"
  end

  def timing data
    set_room data["roomId"]
    @room.update_duration data["duration"].to_f
  end

  def remove_person data
    set_room data["roomId"]
    payload = data["data"]
    user_room = UserRoom.find_by_with_cache(user_id: current_user.id, room_id: @room.id)

    if user_room.moderator?
      UserRoom.where(user_id: payload["user_id"], room_id: @room.id).destroy_all
      broadcaster "rooms/#{@room.slug}",
                    type: "evictUser",
                    data: { userId: payload["user_id"] }
    end
  end

  private

  def set_room room_id
    # TODO: find from cache
    @room = Room.find_by slug: room_id
  end

  def valid_vote? payload
    @room.valid_vote_point?(payload["points"].to_s) && payload["story_id"].present?
  end

  def broadcaster channel, *message
    ActionCable.server.broadcast channel, *message
  end

end  