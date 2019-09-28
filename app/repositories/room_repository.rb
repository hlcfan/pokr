class RoomRepository

  def new_entity params
    @params = params

    bulk_import_stories
    add_sequence_to_stories
    permit_params!

    Room.new @params
  end

  def update_entity room, params
    @params = params.merge(status: nil)
    add_sequence_to_stories
    moderator_ids = (@params.delete(:moderator_ids)||"").split(",").map(&:to_i).reject do |moderator_id|
      0 == moderator_id && moderator_id.blank?
    end

    if room.update_attributes @params
      if moderator_ids.length > room.moderator_ids_ary.length
        delta = moderator_ids - room.moderator_ids_ary
        ActiveRecord::Base.transaction do
          delta.each do |moderator_id|
            UserRoom.find_or_create_by(user_id: moderator_id, room_id: room.id).update!(role: UserRoom::MODERATOR)
          end
        end
      elsif moderator_ids.length < room.moderator_ids_ary.length
        delta = room.moderator_ids_ary - moderator_ids
        UserRoom.where(user_id: delta).destroy_all
      elsif moderator_ids.length == room.moderator_ids_ary.length
        UserRoom.where(room_id: room.id, user_id: room.moderator_ids_ary, role: UserRoom::MODERATOR).destroy_all
        user_room_attrs = moderator_ids.map do |moderator_id|
          { user_id: moderator_id, room_id: room.id, role: UserRoom::MODERATOR }
        end
        UserRoom.create user_room_attrs
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
      lines = @params.delete(:bulk_links).split "\r\n"
      return {} if lines.blank?

      stories_hash = {}
      lines.each_with_index do |line, index|
        name, desc = line.split(/\||\t/)
        stories_hash[index.to_s] = { link: name, desc: desc, id: '', _destroy: "false" }
      end
      @params[:stories_attributes] = stories_hash
    else
      @params.delete(:bulk_links)
    end
  end

  def add_sequence_to_stories
    if @params[:stories_attributes]
      index = 0
      @params[:stories_attributes].each_pair do |_, story|
        index += 1
        story[:sequence] = index
      end
    end
  end

  def permit_params!
    if @params[:stories_attributes].is_a? ActionController::Parameters
      @params[:stories_attributes].permit!
    end
  end

end
