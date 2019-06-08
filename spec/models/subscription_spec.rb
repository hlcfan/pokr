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

  describe "#plan_name" do
    it "returns plan name based on user subscription" do
      subscription = Subscription.new(subscription_plan_id: "557855")
      expect(subscription.plan_name).to eq("Quaterly subscription")
    end
  end

  describe ".plans" do
    it "returns current all pricing plans" do
      expect(Subscription.plans).to eq(
        {
          "monthly":    { trial: "542882", normal: "557854", name: "Monthly subscription", fee: 7 },
          "quaterly":   { trial: "555649", normal: "557855", name: "Quaterly subscription", fee: 20 },
          "yearly":     { trial: "552848", normal: "557856", name: "Yearly subscription", fee: 77 },
          "enterprise": { trial: "557853", normal: "557853", name: "Enterprise subscription", fee: 200 }
        }
      )
    end
  end
end
