require 'rails_helper'

RSpec.describe Story, type: :model do
  subject(:story) { Story.new }

  describe "#link" do
    it "is invalid if no link specified" do
      expect(story.valid?).to be false
      expect(story.errors[:link]).to include "can't be blank"
    end

    it "is valid if link specified" do
      story.link = 'link'
      expect(story.valid?).to be true
    end

    it "is valid if link contains emoji" do
      story = Story.create(link: "😀😀😀")
      expect(story.valid?).to be true
    end
  end

  describe "#description" do
    it "is valid if description contains emoji" do
      story = Story.create(link: "😀😀😀", desc: "description😀")
      expect(story.valid?).to be true
    end
  end
end
