require 'rails_helper'

RSpec.describe StoryHelper, type: :helper do
  describe "#symbol_point_hash" do
    it "returns symbol according to point" do
      expect(symbol_point_hash(1)).to eq 1
      expect(symbol_point_hash("coffee")).to eq "☕"
      expect(symbol_point_hash("?")).to eq "⁉️"
      expect(symbol_point_hash("null")).to eq "skipped"
    end
  end
end
