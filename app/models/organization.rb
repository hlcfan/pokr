class Organization < ApplicationRecord

  include UidGeneration

  validates_presence_of :name

  belongs_to :creator, class_name: "User", foreign_key: :created_by

  has_many :user_organizations
  has_many :users, -> { order("user_organizations.created_at") }, through: :user_organizations

  def self.members organization_id
    User
      .left_joins(:organization)
      .left_joins(:user_organization)
      .where("organizations.id = ?", organization_id)
      .select(:id, :uid, :email, :name, :image)
      .select("organizations.name as organization_name")
      .select("user_organizations.role as organization_role")
      .order("user_organizations.created_at")
      .group_by {|u| u.attributes["organization_name"]}
      .inject({}) do |h, (organization_name, members)|
        h[organization_name] = members.uniq
        h
      end
  end

end
