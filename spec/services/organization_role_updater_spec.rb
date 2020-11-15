require 'rails_helper'

RSpec.describe OrganizationRoleUpdater do
  describe ".switch_admin" do
    it "sets org role to admin if not admin" do
      user1 = User.create(email: "a@a.com", password: "password")
      user2 = User.create(email: "b@b.com", password: "password")

      org = Organization.create(name: "my org")

      user_org1 = UserOrganization.create({user_id: user1.id, organization_id: org.id})
      user_org2 = UserOrganization.create({user_id: user2.id, organization_id: org.id})

      success = OrganizationRoleUpdater.switch_admin(org.id, org.uid, user2.uid)
      user_org2.reload

      expect(user_org2.role).to eq(2)
      expect(success).to be_truthy
    end

    it "unsets org role to default if admin" do
      user1 = User.create(email: "a@a.com", password: "password")
      user2 = User.create(email: "b@b.com", password: "password")

      org = Organization.create(name: "my org")

      user_org1 = UserOrganization.create({user_id: user1.id, organization_id: org.id})
      user_org2 = UserOrganization.create({user_id: user2.id, organization_id: org.id, role: 2})

      success = OrganizationRoleUpdater.switch_admin(org.id, org.uid, user2.uid)
      user_org2.reload

      expect(user_org2.role).to eq(1)
      expect(success).to be_truthy
    end
  end
end
