require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe "Associations" do
    it "has many user_teams" do
      expect(Organization.reflect_on_association(:user_organizations).macro).to eq(:has_many)
    end

    it "has many users" do
      expect(Organization.reflect_on_association(:users).macro).to eq(:has_many)
    end

    it "belongs to creator" do
      expect(Organization.reflect_on_association(:creator).macro).to eq(:belongs_to)
    end
  end

  describe ".members" do
    it "returns members for an org" do
      user1 = User.create(email: 'a@a.com', password: 'password')
      user2 = User.create(email: 'b@b.com', password: 'password')
      user3 = User.create(email: 'c@c.com', password: 'password')

      org1 = Organization.create(name: "org A")

      UserOrganization.create([
        {user_id: user1.id, organization_id: org1.id},
        {user_id: user2.id, organization_id: org1.id},
        {user_id: user3.id, organization_id: org1.id}
      ])

      members = Organization.members(org1.id)
      expect(members.length).to eq(1)

      members = members.first
      member_ids = members[:members].collect { |u| u.id }

      expect(members[:name]).to eq("org A")
      expect(members[:uid]).to eq(org1.uid)
      expect(member_ids).to eq([user1.id, user2.id, user3.id])
    end
  end
end
