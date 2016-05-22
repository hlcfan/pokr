class UserRoom < ActiveRecord::Base

  belongs_to :user
  belongs_to :room

  OWNER = 0
  PARTICIPANT = 1
  WATCHER = 2

  def display_role
    case self.role
    when 0
      'Owner'
    when 1
      'Participant'
    else
      'Watcher'
    end
  end

end
