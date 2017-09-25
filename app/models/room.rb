# frozen_string_literal: true

class Room < ApplicationRecord

  validates_presence_of :name

  has_many :user_rooms
  has_many :users, through: :user_rooms
  has_many :stories, -> { order(:sequence) }, dependent: :destroy

  belongs_to :creator, class_name: "User", foreign_key: :created_by

  accepts_nested_attributes_for :stories, allow_destroy: true

  before_create :slug!
  before_save :sort_point_values
  after_initialize :default_values

  attr_accessor :moderator_ids

  OPEN = 1
  DRAW = 2
  POINT_SCHEMES = {
    "fibonacci" => %w(0 1 2 3 5 8 13 20 40 100 ? coffee),
    "0-8" => %w(0 1 2 3 4 5 6 7 8 ? coffee)
  }

  FREESTYLE = 1

  def state
    if FREESTYLE == self.style
      { Room::OPEN => 'open' }
    else
      { Room::OPEN => 'open', Room::DRAW => 'draw' }
    end.fetch(self.status, 'not-open')
  end

  def free_style?
    FREESTYLE == self.style
  end

  def display_state
    if state == "draw"
      "Finished"
    else
      "In Progress"
    end
  end

  def grouped_stories
    stories_grouped = stories.group_by do |story|
      story.point.present?
    end

    { groomed: stories_grouped[true], ungroomed: stories_grouped[false] }
  end

  def groomed_stories
    stories.where("point IS NOT NULL").pluck(:id, :link, :point)
  end

  def summary
    story_ids = stories.map &:id
    users_hash = {}
    users.each do |user|
      users_hash.update(user.id => { name: user.display_name, avatar: user.letter_avatar })
    end
    user_story_points = UserStoryPoint.where(story_id: story_ids, user_id: users_hash.keys)
    user_story_points_hash = Hash.new {|hsh, key| hsh[key] = [] }
    user_story_points.each do |user_story_point|
      user_story_points_hash[user_story_point.story_id] << {
        user_id: user_story_point.user_id,
        user_points: user_story_point.points,
        user_name: users_hash[user_story_point.user_id][:name],
        user_avatar: users_hash[user_story_point.user_id][:avatar]
      }
    end

    stories_list = stories.where("point IS NOT NULL").pluck(:id, :link, :point)

    stories_list.map do |story|
      {
        id: story[0],
        link: story[1],
        point: story[2],
        individuals: user_story_points_hash[story[0]]
      }
    end
  end

  def current_story_id
    @current_story_id ||= begin
      if story_id = un_groomed_stories.pluck(:id).first
        story_id
      end
    end
  end

  def point_values
    @point_values ||= self.pv.split(',')
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

  # def time_duration
  #   return duration if duration.present?

  #   @time_duration ||= begin
  #     all_stories = stories.to_a
  #     first_story = all_stories.first
  #     last_story = all_stories.last
  #     if first_story.present? && last_story.present?
  #       Rails.cache.fetch "duration:#{id}:#{first_story.id}:#{last_story.id}" do
  #         calc_duration_between first_story, last_story
  #       end
  #     end || 0
  #   end
  # end

  def user_list params={}
    user_story_points = (UserStoryPoint.joins(user: :user_rooms)
      .where("user_rooms.user_id = user_story_points.user_id AND user_story_points.story_id = ?", current_story_id)
      .inject({}) do |h, user_story_point|
      h[user_story_point.user_id] = user_story_point.points
      h
    end if current_story_id) || {}

    room_users = User.joins(:user_rooms).where("user_rooms.user_id = users.id AND user_rooms.room_id = ?", id)
      .order("user_rooms.created_at")
      .select(:id, :role, :name, :avatar_file_name, :avatar_content_type, :avatar_file_size, :image)
      .select("user_rooms.role as role")
      .inject([]) do |array, user|
      array.push({
        id: user.id,
        name: user.display_name,
        display_role: display_role(user.role),
        avatar_thumb: user.letter_avatar,
        voted: user.voted = user_story_points.key?(user.id),
        points: (params[:sync] == 'true' ? user_story_points[user.id] : "")
      })
    end

    room_users.partition do |room_user|
      room_user[:display_role] != "Watcher"
    end.flatten
  end

  def moderator_hash
    if moderators.present?
      moderators.map do |user_id, user_name|
        { value: user_id, name: user_name }
      end
    end
  end

  def moderator_ids_ary
    @moderator_ids_ary ||= begin
      if moderators.present?
        moderators.map { |user_id, user_name| user_id }
      else
        []
      end
    end
  end

  def update_duration period
    if period > self.duration.to_f
      self.update_attribute :duration, period

      self
    end
  end

  def pv_for_form
    point_values.join(",")
  end

  private

  def moderators
    @moderator ||= begin
      moderator_ids = UserRoom.where(room_id: id, role: UserRoom::MODERATOR).pluck(:user_id)
      User.where(id: moderator_ids).pluck(:id, :name).reject do |user_id, user_name|
        user_id == created_by
      end
    end
  end

  def has_timer?
    !!timer
  end

  def slug!
    # if it's latin letters
    permlink = if /^[a-zA-Z0-9_\-\/+ ]*$/ =~ name
      name.parameterize
    else
      PinYin.permlink(name).downcase
    end

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
    if self.pv_changed? || self.scheme_changed?
      self.pv = self.pv.split(',').sort_by do |value|
        POINT_SCHEMES[self.scheme].index value
      end.join(',')
    end
  end

  # def calc_duration_between first_story, last_story
  #   user_votes = UserStoryPoint.where(story_id: [first_story.id, last_story.id]).order("updated_at DESC").pluck(:updated_at)
  #   if user_votes.present?
  #     duration_in_seconds = (user_votes.first - user_votes.last).abs
  #     # throw away the duration if larger than 5 hours
  #     duration_in_seconds < 18000 ? duration_in_seconds : 0
  #   end
  # end

  def un_groomed_stories
    stories.where(point: nil)
  end

  def display_role role
    case role
    when 0
      'Moderator'
    when 1
      'Participant'
    else
      'Watcher'
    end
  end

  def default_values
    self.scheme ||= "fibonacci"
    self.pv ||= POINT_SCHEMES["fibonacci"].join(",")
  end

end
