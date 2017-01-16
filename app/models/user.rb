class User < ApplicationRecord

  include LetterAvatar::AvatarHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "100x100", thumb: "30x30" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :avatar, :in => 0.megabytes..2.megabytes
  after_validation -> { errors.delete(:avatar) }

  validates_presence_of :name

  has_many :user_rooms
  has_many :rooms, through: :user_rooms
  has_many :user_story_points
  has_many :created_rooms, class_name: "Room", foreign_key: :created_by

  after_initialize :default_values

  attr_accessor :points, :display_role, :voted, :avatar_thumb

  OWNER = 0
  PARTICIPANT = 1
  WATCHER = 2

  def points_of_story story_id
    return nil if story_id.blank?
    point = user_story_points.where(story_id: story_id).pluck(:points).first
    point if point
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

  def display_name
    name || email
  end

  def default_values
    self.name ||= email.split('@').first
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def stories_groomed_count
    @stories_groomed_count ||= UserStoryPoint.where(user_id: id).count
  end

  def letter_avatar size=:thumb
    if avatar?
      avatar.url size
    else
      letter_avatar_url name_in_letter, 100
    end
  end

  private

  def name_in_letter
    unless name =~ /^[a-zA-Z0-9]+/
      PinYin.abbr name
    else
      name
    end
  end

end
