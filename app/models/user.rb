class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name

  has_many :user_rooms
  has_many :rooms, through: :user_rooms

  has_many :user_story_points

  after_initialize :default_values

  attr_accessor :points, :display_role

  OWNER = 0
  PARTICIPANT = 1
  WATCHER = 2

  def points_of_story story_id
    return nil if story_id.blank?
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

  def display_name
    name || email
  end

  def default_values
    self.name ||= email.split('@').first
  end

end
