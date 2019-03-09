require 'rails_helper'

RSpec.describe UserStoryPoint, type: :model do
  describe ".vote" do
    let(:user_id) { 1 }
    let(:story) { Story.create(link: "story") }

    it "creates record when user votes first time" do
      UserStoryPoint.vote user_id, story.uid, 13
      expect(UserStoryPoint.find_by(user_id: user_id, story_id: story.id).points).to eq "13"
    end

    it "updates record when user re-vote" do
      UserStoryPoint.vote user_id, story.uid, 21
      expect(UserStoryPoint.find_by(user_id: user_id, story_id: story.id).points).to eq "21"
    end

    it "updates comment if comment is present" do
      UserStoryPoint.vote user_id, story.uid, 21, "my comments"
      expect(UserStoryPoint.find_by(user_id: user_id, story_id: story.id).comment).to eq "my comments"
    end

    it "doesn't updates comment if no comment " do
      UserStoryPoint.vote user_id, story.uid, 21
      expect(UserStoryPoint.find_by(user_id: user_id, story_id: story.id).comment).to be_nil
    end
  end
end
