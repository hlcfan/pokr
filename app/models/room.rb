class Room < ApplicationRecord

  validates_presence_of :name

  has_many :user_rooms
  has_many :users, through: :user_rooms
  has_many :stories, dependent: :destroy

  belongs_to :creator, class_name: "User", foreign_key: :created_by

  accepts_nested_attributes_for :stories, allow_destroy: true

  before_create :slug!
  before_save :sort_point_values

  OPEN = 1
  DRAW = 2
  DEFAULT_POINT_VALUES = %w(0 1 2 3 5 8 13 20 40 100 ? coffee)

  def state
    {
      Room::OPEN => 'open',
      Room::DRAW => 'draw'
    }.fetch(self.status, 'not-open')
  end

  def display_state
    if state == "draw"
      "Finished"
    else
      "In Progress"
    end
  end

  def un_groomed_stories
    stories.where(point: nil)
  end

  def groomed_stories
    stories.where "point IS NOT NULL"
  end

  def current_story_id
    if story_id = un_groomed_stories.pluck(:id).first
      story_id
    end
  end

  def point_values
    @point_values ||= begin
      if self.pv.blank?
        DEFAULT_POINT_VALUES
      else
        self.pv.split ','
      end
    end
  end

  def valid_vote_point? point
    ("null" == point) || point_values.include?(point)
  end

  def timer_interval
    if has_timer?
      # unit in minute, defaults to 1 minute
      (timer || 1).to_i * 60
    else
      0
    end
  end

  private

  def has_timer?
    !!timer
  end

  def slug!
    permlink = PinYin.permlink(name).downcase
    if Room.find_by(slug: permlink).present?
      permlink = "#{permlink}-#{SecureRandom.random_number(100000)}"
    end

    # Solution 2:
    # self.slug = loop do
    #   token = SecureRandom.hex(10)
    #   unless Room.find_by(slug: permlink).exists?
    #     break token
    #   end
    # end

    self.slug = permlink
  end

  def sort_point_values
    if self.pv_changed?
      self.pv = self.pv.split(',').sort_by do |value|
        DEFAULT_POINT_VALUES.index value
      end.join(',')
    end
  end

end
