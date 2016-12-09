require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.new }

  describe "#name" do
    it "is invalid if name is blank" do
      expect(user.valid?).to be false
      expect(user.errors[:name]).to include "can't be blank"
    end
  end

  describe "#default_values" do
    it "sets default values after initialize" do
      user = User.new email: "alex@a.com"
      expect(user.name).to eq "alex"
    end
  end

  describe "#points_of_story" do
    it "returns the point user voted for a story" do
      user = User.create(email: 'a@a.com', password: 'password')
      story = Story.create(link: 'http://jira.com/123')
      user_story_point = UserStoryPoint.create user_id: user.id, story_id: story.id, points: 13
      expect(user.points_of_story(story.id)).to eq "13"
    end
  end

  describe "#owner?" do
    it "returns true if role equals 0" do
      user.role = 0
      expect(user.owner?).to be true
    end
  end

  describe "#participant?" do
    it "returns true if role equals 1" do
      user.role = 1
      expect(user.participant?).to be true
    end
  end

  describe "#watcher?" do
    it "returns true if role equals 2" do
      user.role = 2
      expect(user.watcher?).to be true
    end
  end

  describe "#display_name" do
    it "prefers email user name" do
      user.name = 'nickname'
      expect(user.display_name).to eq "nickname"
    end

    it "shows email address if user name does not exist" do
      user.email = 'a@a.com'
      expect(user.display_name).to eq "a@a.com"
    end
  end

  describe "#stories_groomed_count" do
    it "simply returns stories user voted" do
      user = User.create(email: 'a@a.com', password: 'password')
      UserStoryPoint.create(user_id: user.id, story_id: 1, points: 1)
      UserStoryPoint.create(user_id: user.id, story_id: 2, points: 13)
      expect(user.stories_groomed_count).to eq 2
    end
  end

  describe "#time_spent" do
    let!(:room_1) { Room.create(name: "room 1") }
    let!(:room_2) { Room.create(name: "room 2") }
    let!(:story_1) { Story.create(link: "link_1", room_id: room_1.id) }
    let!(:story_2) { Story.create(link: "link_2", room_id: room_1.id) }
    let!(:story_3) { Story.create(link: "link_3", room_id: room_2.id) }
    let!(:story_4) { Story.create(link: "link_4", room_id: room_2.id) }

    it "calculates time spent on grooming" do
      user = User.create(email: 'a@a.com', password: 'password')
      UserRoom.create(user_id: user.id, room_id: room_1.id)
      UserRoom.create(user_id: user.id, room_id: room_2.id)
      UserStoryPoint.create(user_id: user.id, story_id: story_1.id, points: 1)
      sleep 1
      UserStoryPoint.create(user_id: user.id, story_id: story_2.id, points: 3)
      UserStoryPoint.create(user_id: user.id, story_id: story_3.id, points: 8)
      sleep 1
      UserStoryPoint.create(user_id: user.id, story_id: story_4.id, points: 13)

      expect(user.time_spent).to eq 2.0
    end
  end

end
