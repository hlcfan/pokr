require 'rails_helper'

RSpec.describe RetroScheme, type: :model do
  describe ".default" do
    it "returns default schemes" do
      expect(RetroScheme.default.length).to eq 4
    end
  end
end
