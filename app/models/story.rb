class Story < ApplicationRecord

  include PgSearch
  multisearchable :against => [:wrecked_link, :desc], :if => :point?

  validates_presence_of :link

  has_many :user_room_stories
  has_many :user_story_points
  belongs_to :room, counter_cache: true
  scope :available, -> { where(discarded_at: nil) }

  def as_json options=nil
    super({only: [:link, :desc, :point]})
  end

  private

  def wrecked_link
    link.gsub /-|\s+/, " "
  end

end
