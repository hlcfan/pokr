require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe "associations" do
    it "belongs to user" do
      expect(Subscription.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end

  describe "#active?" do
    it "returns true if status equals 1" do
      subscription = Subscription.new(status: 1)
      expect(subscription.active?).to eq(true)

      subscription.status = 0
      expect(subscription.active?).to eq(false)
    end
  end
end
