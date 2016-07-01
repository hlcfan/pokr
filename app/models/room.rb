class Room < ActiveRecord::Base

  validates_presence_of :name

  has_many :user_rooms
  has_many :users, through: :user_rooms
  has_many :stories, dependent: :destroy
  accepts_nested_attributes_for :stories, allow_destroy: true

  before_create :slug!

  OPEN = 1

  def open?
    OPEN == self.status
  end

  def un_groomed_stories
    stories.where(point: nil)
  end

  def groomed_stories
    stories.where "point IS NOT NULL"
  end

  def current_story_id
    if current_story = un_groomed_stories.first
      current_story.id
    end
  end

  def slug!
    permlink = PinYin.permlink(name).downcase
    if Room.find_by(slug: permlink).present?
      permlink = "#{permlink}-#{SecureRandom.random_number(100000)}"
    end

    self.slug = permlink
  end

end
