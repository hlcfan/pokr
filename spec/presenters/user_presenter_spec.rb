require 'rails_helper'

RSpec.describe UserPresenter do
  let(:user) { User.create(email: 'a@a.com', password: 'password') }
  subject(:user_presented) { UserPresenter.new user }

  describe "#participated_rooms" do
    it "returns user participated rooms" do
      room_1 = Room.create(name: "room 1")
      sleep 1
      room_2 = Room.create(name: "room 2")
      UserRoom.create(user_id: user.id, room_id: room_1.id)
      UserRoom.create(user_id: user.id, room_id: room_2.id)

      expect(user_presented.participated_rooms).to eq [room_2, room_1]
      expect(user_presented.participated_rooms.first).to eq room_2
    end
  end

  describe "#recent_stories" do
    it "returns recent groomed stories by current user" do
      story_1 = Story.create(link: 'http://jira.com/123', point: 1)
      sleep 1
      story_2 = Story.create(link: 'http://jira.com/345', point: 3)
      story_3 = Story.create(link: 'http://jira.com/567')
      UserStoryPoint.create(user_id: user.id, story_id: story_1.id, points: 1)
      UserStoryPoint.create(user_id: user.id, story_id: story_2.id, points: 3)
      UserStoryPoint.create(user_id: user.id, story_id: story_3.id, points: 8)

      expect(user_presented.recent_stories).to eq [story_2, story_1]
    end
  end

  describe "#timestamp_for_line_chart" do
    it "returns array of timestamps of each room participated" do
      room_1 = Room.create(name: "room 1")
      room_2 = Room.create(name: "room 2")
      UserRoom.create(user_id: user.id, room_id: room_1.id)
      UserRoom.create(user_id: user.id, room_id: room_2.id)

      expect(user_presented.timestamp_for_line_chart).to eq [Time.now.strftime("%b %d")]*2
    end
  end

  describe "#story_size_for_line_chart" do
    it "returns array of timestamps of each room participated" do
      room_1 = Room.create(name: "room 1")
      room_2 = Room.create(name: "room 2")
      story_1 = Story.create(link: 'http://jira.com/123', room_id: room_1.id)
      story_1 = Story.create(link: 'http://jira.com/345', room_id: room_2.id)
      UserRoom.create(user_id: user.id, room_id: room_1.id)
      UserRoom.create(user_id: user.id, room_id: room_2.id)

      expect(user_presented.story_size_for_line_chart).to eq [1, 1]
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
      UserRoom.create(user_id: user.id, room_id: room_1.id)
      UserRoom.create(user_id: user.id, room_id: room_2.id)
      UserStoryPoint.create(user_id: user.id, story_id: story_1.id, points: 1)
      sleep 1
      UserStoryPoint.create(user_id: user.id, story_id: story_2.id, points: 3)
      UserStoryPoint.create(user_id: user.id, story_id: story_3.id, points: 8)
      sleep 1
      UserStoryPoint.create(user_id: user.id, story_id: story_4.id, points: 13)

      expect(user_presented.time_spent).to eq 2.0
    end
  end

  describe "#skip_rate" do
    let!(:story_1) { Story.create(link: "link_1", room_id: 1, point: 3) }
    let!(:story_2) { Story.create(link: "link_2", room_id: 1, point: "null") }

    it "returns skip rate if user voted any stories" do
      UserStoryPoint.create(user_id: user.id, story_id: story_1.id, points: 1)
      UserStoryPoint.create(user_id: user.id, story_id: story_2.id, points: 3)

      expect(user_presented.skip_rate).to eq 50.0
    end

    it "returns 0 if user havent voted any stories" do
      expect(user_presented.skip_rate).to eq 0
    end
  end

  describe "#avg_per_story" do
    it "returns average time per story if have groomed stories" do
      UserStoryPoint.create(user_id: user.id, story_id: 1, points: 1)
      UserStoryPoint.create(user_id: user.id, story_id: 2, points: 3)

      allow(user_presented).to receive(:time_spent) { 100 }
      expect(user_presented.avg_per_story).to eq 50.0
    end

    it "returns 0 if havent groomed any stories" do
      expect(user_presented.avg_per_story).to eq 0
    end
  end
end
