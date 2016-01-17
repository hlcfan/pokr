class User < ActiveRecord::Base

  validates_uniqueness_of :name

  has_many :user_rooms
  has_many :rooms, through: :user_rooms

  has_many :user_story_points

  attr_accessor :points, :display_role

  OWNER = 0
  PARTICIPANT = 1
  WATCHER = 2

  def points_of_story story_id
    point = user_story_points.where(story_id: story_id).first
    point.points if point
  end

  def owner?
    role == 0
  end

  def participant?
    role == 1
  end

  def watcher?
    role == 2
  end

  def owner!
    self.role = 1
    save!
  end

  def display_role
    case self.role
    when 0
      'Owner'
    when 1
      'Participant'
    when 2
      'Watcher'
    else
      'Who?'
    end
  end

end
