class OrganizationRoleUpdater
  def self.switch_admin current_org_id, org_uid_to_update, user_uid_to_update
    user_org_to_update = UserOrganization.joins(:user, :organization)
      .where("users.uid = ?", user_uid_to_update)
      .where("organizations.uid = ?", org_uid_to_update)
      .limit(1).first

    if user_org_to_update.organization_id == current_org_id
      if UserOrganization.admin?(user_org_to_update.role)
        user_org_to_update.update_attribute(:role, UserOrganization::ROLE_DEFAULT)
      else
        user_org_to_update.update_attribute(:role, UserOrganization::ROLE_ADMIN)
      end

      true
    end
  end
end
