module RoomCommunication

  def self.vote room, current_user, params
    # binding.pry
    payload = params["data"]
    if valid_vote? room, payload
      UserStoryPoint.vote(current_user.id,
                      payload["story_id"],
                      payload["points"])
      {
        type: "notify",
        person_id: current_user.uid
      }
    end
  end

  def self.action room, current_user, params
    if params["data"] == "open"
      room.update_attribute(:status, Room::OPEN) if room
    end

    { :data => params["data"], :type => params["type"] }
  end

  def self.set_story_point room, current_user, params
    payload = params["data"]
    user_room = UserRoom.find_by_with_cache(user_id: current_user.id, room_id: room.id)

    if user_room&.moderator? && room.valid_vote_point?(payload["point"])
      story = Story.find_by uid: payload["story_id"], room_id: room.id
      if story
        story_point = room.free_style? ? nil : payload["point"]
        story.update_attribute :point, story_point
        if room.free_style?
          UserStoryPoint.where(story_id: story.id).destroy_all
        end
        room.update_attribute :status, nil
        return {
          type: "action",
          data: "next-story"
        }
      end
    end
  end

  def self.remove_person params
    payload = params["data"]
    user_room = UserRoom.find_by_with_cache(user_id: current_user.id, room_id: room.id)

    if user_room&.moderator?
      participant = User.find_by(uid: payload["user_id"])
      UserRoom.where(user_id: participant.id, room_id: room.id).destroy_all
      
      return {
        type: "evictUser",
        data: { userId: payload["user_id"] }
      }
    end
  end

  def self.timing room, current_user, params
    room.update_duration params["duration"].to_f
    return {}
  end

  def self.revote room, current_user, params
    payload = params["data"]
    user_room = UserRoom.find_by_with_cache(user_id: current_user.id, room_id: room.id)

    if user_room&.moderator?
      story = Story.find_by uid: payload["story_id"], room_id: room.id
      if story
        story.update_attribute :point, nil
        room.update_attribute :status, nil
        
        return {
          type: "action",
          data: "revote"
        }
      end
    end
  end

  def self.clear_votes room, current_user, params
    payload = params["data"]
    user_room = UserRoom.find_by_with_cache(user_id: current_user.id, room_id: room.id)

    if user_room&.moderator?
      UserStoryPoint.where(story_id: payload["story_id"]).delete_all
      room.update_attribute :status, nil
      return {
        type: "action",
        data: "clear-votes"
      }
    end
  end

  def self.valid_vote? room, payload
    room.valid_vote_point?(payload["points"].to_s) && payload["story_id"].present?
  end

end
