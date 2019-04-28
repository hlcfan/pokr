require 'rails_helper'

RSpec.describe BillingHelper, type: :helper do
  describe "#upgrade_button_text" do
    it "returns trial text if user signed in less than 30 days" do
      allow(helper).to receive(:current_user) { double(:user, :created_at => 1.day.ago) }
      expect(helper.upgrade_button_text).to eq("Try free for 30 days")
    end

    it "returns Upgrade if exceed trial date" do
      allow(helper).to receive(:current_user) { double(:user, :created_at => 1.month.ago) }
      expect(helper.upgrade_button_text).to eq("Upgrade")
    end
  end
end
