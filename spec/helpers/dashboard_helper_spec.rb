require 'rails_helper'

RSpec.describe DashboardHelper, type: :helper do
  describe "#show_story_link" do
    it "returns story link if it's a link" do
      expect(show_story_link("http://a.com")).to eq "http://a.com"
    end

    it "returns javascript:; if it ain't a link" do
      expect(show_story_link("Phase II")).to eq "javascript:;"
    end
  end
end