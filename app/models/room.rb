class Room < ActiveRecord::Base

  has_many :user_rooms
  has_many :users, through: :user_rooms
  has_many :stories

  def un_groomed_stories
    stories.where(point: nil)
  end

end
