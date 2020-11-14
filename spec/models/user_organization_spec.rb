require 'rails_helper'

RSpec.describe UserOrganization, type: :model do
  describe "Associations" do
    it "belongs to user" do
      expect(UserOrganization.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "belongs to organization" do
      expect(UserOrganization.reflect_on_association(:organization).macro).to eq(:belongs_to)
    end

    it "has many users" do
      expect(Organization.reflect_on_association(:users).macro).to eq(:has_many)
    end
  end

  describe ".admin?" do
    it "returns true if admin role" do
      expect(UserOrganization.admin?(1)).to be false

      expect(UserOrganization.admin?(2)).to be true
    end
  end
end
