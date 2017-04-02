class RoomRepository

  def new_entity params
    @params = params

    bulk_import_stories

    Room.new @params
  end

  def update_entity room, params
    moderator_ids = (params.delete(:moderator_ids)||"").split(",").map(&:to_i).reject do |moderator_id|
      0 == moderator_id && moderator_id.blank?
    end
    if room.update_attributes params
      if moderator_ids.length > room.moderator_ids_ary.length
        delta = moderator_ids - room.moderator_ids_ary
        user_room_attrs = delta.map do |moderator_id|
          { user_id: moderator_id, room_id: room.id, role: UserRoom::MODERATOR }
        end
        UserRoom.create user_room_attrs
      elsif moderator_ids.length < room.moderator_ids_ary.length
        delta = room.moderators_id - moderator_ids
        UserRoom.destroy_all(user_id: delta)
      end

      room
    end
  end

  def save room
    if room.save
      moderator_ids = room_moderators room.moderator_ids, room.created_by
      user_room_attrs = moderator_ids.map do |moderator_id|
        { user_id: moderator_id, room_id: room.id, role: UserRoom::MODERATOR }
      end

      UserRoom.create user_room_attrs

      room
    end
  end

  private

  def room_moderators moderator_ids_string, created_by
    if moderator_ids_string.present?
      moderator_ids_string.split(",") << created_by
    else
      [created_by]
    end
  end

  def bulk_import_stories
    if "true" == @params.delete(:bulk)
      links = @params.delete(:bulk_links).split "\r\n"
      return {} if links.blank?

      stories_hash = {}
      links.each_with_index do |story_link, index|
        stories_hash[index.to_s] = { link: story_link, desc: '', id: '', _destroy: "false" }
      end

      @params[:stories_attributes] = stories_hash
    else
      @params.delete(:bulk_links)
    end
  end

end