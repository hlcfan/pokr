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

    it "updates comment if comment is present" do
      UserStoryPoint.vote user_id, story_id, 20, "my comments"
      expect(UserStoryPoint.find_by(user_id: user_id, story_id: story_id).comment).to eq "my comments"
    end

    it "doesn't updates comment if no comment " do
      UserStoryPoint.vote user_id, story_id, 20
      expect(UserStoryPoint.find_by(user_id: user_id, story_id: story_id).comment).to be_nil
    end
  end

  describe "#encoded_id" do
    it "returns encoded id" do
      vote = UserStoryPoint.new(user_id: 1, story_id: 1, points: "13")
      allow(vote).to receive(:id) { 1 }
      expect(vote.encoded_id).to eq("4d513d3d")
    end
  end

  describe ".decoded_id" do
    it "decodes encoded id" do
      expect(UserStoryPoint.decoded_id("4d513d3d")).to eq("1")
    end
  end
end
