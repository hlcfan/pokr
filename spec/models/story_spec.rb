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

  describe "#as_json" do
    it "returns only link, description and point" do
      story.link = "Link"
      story.desc = "Ticket description"
      story.point= "13"
      expect(story.as_json).to eq({"link"=>"Link", "desc"=>"Ticket description", "point"=>"13"})
    end
  end

  describe "#related_to_user?" do
    it "returns true if user joined the room where the story belongs to" do
      user = User.create(email: 'a@a.com', password: 'password')
      room = Room.create!(name: "a room")
      story = Story.create(link: "story name", room_id: room.id)
      UserRoom.create(user_id: user.id, room_id: room.id)
      PgSearch::Multisearch.rebuild(Story)

      expect(story.related_to_user?(user.id)).to be true
    end

    it "returns false user joined the room where the story doesn't belong to" do
      user = User.create(email: 'a@a.com', password: 'password')
      room = Room.create!(name: "a room")
      story = Story.create(link: "story name", room_id: room.id)
      PgSearch::Multisearch.rebuild(Story)

      expect(story.related_to_user?(user.id)).to be false
    end
  end
end
