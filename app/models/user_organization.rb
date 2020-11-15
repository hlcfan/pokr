class UserOrganization < ApplicationRecord

  ROLE_DEFAULT = 1
  ROLE_ADMIN   = 2

  belongs_to :user
  belongs_to :organization

  def self.admin? role
    ROLE_ADMIN == role
  end

  def same_organization? uid1, uid2
    UserOrganization.joins(:user).where("users.uid in (?)", [uid1, uid2])
  end

end
