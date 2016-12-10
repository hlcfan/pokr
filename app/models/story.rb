class Story < ApplicationRecord

  validates_presence_of :link

  has_many :user_room_stories
  belongs_to :room, counter_cache: true

end
