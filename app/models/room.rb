class Room < ActiveRecord::Base

  validates_presence_of :name

  has_many :user_rooms
  has_many :users, through: :user_rooms
  has_many :stories, dependent: :destroy
  accepts_nested_attributes_for :stories, allow_destroy: true

  def un_groomed_stories
    stories.where(point: nil)
  end

end
