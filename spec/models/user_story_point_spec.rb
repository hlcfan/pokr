require 'rails_helper'

RSpec.describe UserStoryPoint, type: :model do
  describe ".vote" do
    let(:user) { User.create(email: "a@a.com", password: "password") }
    let(:room) { Room.create(name: "test", created_by: user.id) }
    let(:story) { Story.create(link: "story", room_id: room.id) }

    it "creates record when user votes first time" do
      UserStoryPoint.vote user.id, story.id, 13
      expect(UserStoryPoint.find_by(user_id: user.id, story_id: story.id).points).to eq "13"
    end

    it "updates record when user re-vote" do
      UserStoryPoint.vote user.id, story.id, 21
      expect(UserStoryPoint.find_by(user_id: user.id, story_id: story.id).points).to eq "21"
    end

    it "updates comment if comment is present" do
      UserStoryPoint.vote user.id, story.id, 21, "my comments"
      expect(UserStoryPoint.find_by(user_id: user.id, story_id: story.id).comment).to eq "my comments"
    end

    it "doesn't updates comment if no comment " do
      UserStoryPoint.vote user.id, story.id, 21
      expect(UserStoryPoint.find_by(user_id: user.id, story_id: story.id).comment).to be_nil
    end
  end
end
