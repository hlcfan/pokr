class User < ApplicationRecord

  include UidGeneration
  include LetterAvatar::AvatarHelper
  EMAIL_PREFIX = "pokrex"
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_attached_file :avatar, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :avatar, :in => 0.megabytes..2.megabytes
  after_validation -> { errors.delete(:avatar) }

  validates_presence_of :name

  has_many :user_rooms
  has_many :rooms, through: :user_rooms
  has_many :user_story_points
  has_many :created_rooms, class_name: "Room", foreign_key: :created_by
  has_many :authorizations
  has_many :schemes
  has_many :orders
  has_many :subscriptions

  after_initialize :default_values

  after_avatar_post_process :set_avatar_as_image

  attr_accessor :points, :display_role, :voted, :avatar_thumb

  OWNER = 0
  PARTICIPANT = 1
  WATCHER = 2

  def admin?
    1 == id
  end

  def points_of_story story_id
    return nil if story_id.blank?
    point = user_story_points.where(story_id: story_id).pluck(:points).first
    point if point
  end

  def display_name
    name || email
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def stories_groomed_count
    @stories_groomed_count ||= UserStoryPoint.where(user_id: id).count
  end

  def letter_avatar
    if avatar? || image?
      image || avatar.url(:medium)
    else
      letter_avatar_url name_in_letter, 100
    end
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = Authorization.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?
      email = auth.info.email
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{EMAIL_PREFIX}-#{auth.uid}@#{auth.provider}.com",
          password: Devise.friendly_token[0,20],
        )
      end
    end

    user.image = auth.info.image if auth.info.image
    user.save! if user.changed?

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email =~ VALID_EMAIL_REGEX
  end

  def expand_premium_expiration duration
    self.premium_expiration ||= Time.now.utc
    self.premium_expiration += duration

    save!
  rescue
    Rails.logger.error "Expand premium expiration failure for #{id}, duration: #{duration}"
  end

  def premium?
    self.premium_expiration.present? && self.premium_expiration >= Time.now.utc
  end

  def subscription_active?
    subscriptions && subscriptions.last&.active?
  end

  def subscription_cancel_url
    subscriptions && subscriptions.last&.cancel_url
  end

  private

  def default_values
    self.name ||= email.split('@').first if new_record?
  end

  def name_in_letter
    unless name =~ /^[a-zA-Z0-9]+/
      PinYin.abbr name
    else
      name
    end
  end

  def set_avatar_as_image
    self.image = avatar.url :medium
  end

end
