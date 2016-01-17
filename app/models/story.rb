class Story < ActiveRecord::Base

  has_many :user_room_stories
  belongs_to :room

end
