require 'rails_helper'

RSpec.describe BillingHelper, type: :helper do
  describe "#upgrade_button_text" do
    it "returns trial text if user signed in less than 30 days" do
      allow(helper).to receive(:current_user) { double(:user, :created_at => 1.day.ago) }
      expect(helper.upgrade_button_text).to eq("Try free for 30 days")
    end

    it "returns Upgrade if exceed trial date" do
      allow(helper).to receive(:current_user) { double(:user, :created_at => 2.month.ago) }
      expect(helper.upgrade_button_text).to eq("Upgrade")
    end
  end

  describe "#billing_plan_category" do
    it "returns trial if user is on trial" do
      allow(helper).to receive(:current_user) { double(:user, :created_at => 1.day.ago) }
      expect(helper.billing_plan_category).to eq("trial")
    end

    it "returns normal if exceed trial duration" do
      allow(helper).to receive(:current_user) { double(:user, :created_at => 2.month.ago) }
      expect(helper.billing_plan_category).to eq("normal")
    end
  end

  describe "#billing_plan" do
    it "returns subscription plan name if not in trial" do
      allow(helper).to receive(:current_user) { double(:user, :created_at => 2.month.ago, :id => 1) }
      Subscription.create(user_id: 1, subscription_plan_id: "557856")
      expect(helper.billing_plan).to eq("Yearly subscription")
    end

    it "returns Free if in trial" do
      allow(helper).to receive(:current_user) { double(:user, :created_at => 2.day.ago) }
      expect(helper.billing_plan).to eq("Free")
    end
  end

  describe "#pricing_select_options" do
    it "returns select options for pricing plans" do
      expect(helper.pricing_select_options).to eq("<option value=\"monthly\" trial_plan_id=\"542882\" normal_plan_id=\"557854\">Monthly subscription - $7</option><option value=\"quaterly\" trial_plan_id=\"555649\" normal_plan_id=\"557855\">Quaterly subscription - $20</option><option value=\"yearly\" trial_plan_id=\"552848\" normal_plan_id=\"557856\">Yearly subscription - $77</option><option value=\"enterprise\" trial_plan_id=\"557853\" normal_plan_id=\"557853\">Enterprise subscription - $200</option>")
    end
  end
end
