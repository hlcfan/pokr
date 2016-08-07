class UserRoom < ApplicationRecord

  belongs_to :user
  belongs_to :room

  MODERATOR = 0
  PARTICIPANT = 1
  WATCHER = 2

  def moderator?
    role == 0
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

  def self.find_by_with_cache *args
    Rails.cache.fetch args do
      find_by(*args)
    end
  end

end
