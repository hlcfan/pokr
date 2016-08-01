require 'rails_helper'

RSpec.describe Story, type: :model do
  subject(:story) { Story.new }

  describe "#link" do
    it "is invalid if no link specified" do
      expect(story.valid?).to be false
      expect(story.errors[:link]).to include "can't be blank"
    end

    it "is valid if name specified" do
      story.link = 'link'
      expect(story.valid?).to be true
    end
  end
end
