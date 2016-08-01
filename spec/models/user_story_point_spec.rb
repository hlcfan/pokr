require 'rails_helper'

RSpec.describe UserStoryPoint, type: :model do
  describe ".vote" do
    let(:user_id) { 1 }
    let(:story_id) { 1 }
    it "creates record when user votes first time" do
      UserStoryPoint.vote user_id, story_id, 13
      expect(UserStoryPoint.find_by(user_id: user_id, story_id: story_id).points).to eq "13"
    end

    it "updates record when user re-vote" do
      UserStoryPoint.vote user_id, story_id, 20
      expect(UserStoryPoint.find_by(user_id: user_id, story_id: story_id).points).to eq "20"
    end
  end
end
