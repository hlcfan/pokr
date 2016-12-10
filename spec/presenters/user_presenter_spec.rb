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

  describe "#created_rooms" do
    it "returns user created rooms" do
      room_1 = Room.create(name: "room 1", created_by: user.id)
      room_2 = Room.create(name: "room 2")
      UserRoom.create(user_id: user.id, room_id: room_1.id)
      UserRoom.create(user_id: user.id, room_id: room_2.id)

      expect(user_presented.created_rooms.first).to eq room_1
    end
  end

  describe "#recent_stories" do
    it "returns recent groomed stories" do
      story_1 = Story.create(link: 'http://jira.com/123', point: 1)
      sleep 1
      story_2 = Story.create(link: 'http://jira.com/345', point: 3)
      story_3 = Story.create(link: 'http://jira.com/567')

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
end
