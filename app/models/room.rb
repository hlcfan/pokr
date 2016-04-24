class Room < ActiveRecord::Base

  has_many :user_rooms
  has_many :users, through: :user_rooms
  has_many :stories

end
