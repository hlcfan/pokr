class Scheme < ApplicationRecord

  belongs_to :user

  validates_presence_of :name, :points, :user_id

  before_create :slug!

  def self.default_schemes
    POINT_SCHEMES
  end

  def self.find_scheme scheme_type
    default_schemes[scheme_type] || find_by(slug: scheme_type)&.points
  end

  def self.schemes_of user_id
    Scheme.where(user_id: user_id).inject({}) do |hsh, scheme|
      hsh[scheme.name] = scheme.points

      hsh
    end
  end

  private

  POINT_SCHEMES = {
    "fibonacci" => %w(0 1 2 3 5 8 13 20 40 100 ? coffee),
    "0-8"       => %w(0 1 2 3 4 5 6 7 8 ? coffee),
    "XS-XXL"    => %w(XS S M L XL XXL ? coffee),
    "hours"     => %w(0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 ? coffee)
  }

  def slug!
    # if it's latin letters
    permlink = if /^[a-zA-Z0-9_\-\/+ ]*$/ =~ name
      name.parameterize
    else
      PinYin.permlink(name).downcase
    end

    if Scheme.exists?(slug: permlink)
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
end
