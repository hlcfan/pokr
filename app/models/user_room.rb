class UserRoom < ApplicationRecord

  belongs_to :user
  belongs_to :room, counter_cache: true

  MODERATOR = 0
  PARTICIPANT = 1
  WATCHER = 2

  after_update :clear_cache

  def moderator?
    MODERATOR == role
  end

  def participant?
    PARTICIPANT == role
  end

  def watcher?
    WATCHER == role
  end

  def display_role
    case self.role
    when 0
      'Moderator'
    when 1
      'Participant'
    else
      'Watcher'
    end
  end

  def self.find_by_with_cache user_id:, room_id:
    Rails.cache.fetch "user_room:#{user_id}:#{room_id}" do
      find_by(user_id: user_id, room_id: room_id)
    end
  end

  private

  def clear_cache
    Rails.cache.delete "user_room:#{user_id}:#{room_id}"
  end

end
