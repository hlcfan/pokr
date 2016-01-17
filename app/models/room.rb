class Room < ActiveRecord::Base

  has_many :user_rooms
  has_many :users, through: :user_rooms
  has_many :stories

  # def stories
  #   Story.joins(:user_room_stories).where("user_room_stories.room_id = 1").group(:room_id)
  # end

end
