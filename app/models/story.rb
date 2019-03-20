class Story < ApplicationRecord

  include UidGeneration
  include PgSearch
  multisearchable :against => [:wrecked_link, :desc], :if => :point?

  validates_presence_of :link
  validates_length_of :desc, :maximum => 500

  has_many :user_room_stories
  has_many :user_story_points
  belongs_to :room, counter_cache: true
  scope :available, -> { where(discarded_at: nil) }

  def as_json options=nil
    super({only: [:link, :desc, :point]})
  end

  def related_to_user? user_id
    room.related_to_user? user_id
  end

  private

  def wrecked_link
    link.gsub(/-|\s+/, " ")
  end

end
