require 'rails_helper'

RSpec.describe Room, type: :model do
  subject(:room) { Room.new }

  describe '#name' do
    it "is invalid if no name specified" do
      expect(subject.valid?).to be false
      expect(subject.errors[:name]).to include "can't be blank"
    end

    it "is valid if name specified" do
      room.name = 'name'
      expect(subject.valid?).to be true
    end
  end

  describe "#state" do
    it "is open if status equals 1" do
      room.status = 1
      expect(room.state).to eq "open"
    end

    it "is open if status equals 2" do
      room.status = 2
      expect(room.state).to eq "draw"
    end

    it "is not-open if status not equals 1 or 2" do
      room.status = nil
      expect(room.state).to eq "not-open"
    end
  end

  describe "#display_state" do
    it "is Finished if state equals draw" do
      allow(room).to receive(:state) { "draw" }
      expect(room.display_state).to eq "Finished"
    end

    it "is In Progress if state not equals draw" do
      expect(room.display_state).to eq "In Progress"
    end
  end

  describe "groomed_stories" do
    let!(:story_1) { Story.create(link: "link_1", room_id: 1) }
    let!(:story_2) { Story.create(link: "link_2", room_id: 1, point: 'null') }
    let!(:story_3) { Story.create(link: "link_3", room_id: 1, point: 3) }

    it "returns stories with point set" do
      room.id = 1
      expect(room.groomed_stories).to eq [story_2, story_3]
    end
  end

  describe "#current_story_id" do
    let!(:story_1) { Story.create(link: "link_1", room_id: 1) }
    let!(:story_2) { Story.create(link: "link_2", room_id: 1) }
    let!(:story_3) { Story.create(link: "link_3", room_id: 1, point: 3) }

    it "returns first un groomed story's id" do
      room.id = 1
      expect(room.current_story_id).to eq story_1.id
    end

    it "returns first un groomed story's id by updated_at DESC" do
      sleep 1
      story_2.touch
      room.id = 1
      expect(room.current_story_id).to eq story_2.id
    end    
  end

  describe "#point_values" do
    it "returns default point values if pv is blank" do
      expect(room.point_values).to eq Room::DEFAULT_POINT_VALUES
    end

    it "returns pv splited with comma if pv is present" do
      room.pv = "1,2,3,5,8"
      expect(room.point_values).to eq %w(1 2 3 5 8)
    end
  end

  describe "#valid_vote_point?" do
    it "is true if point is 'null'" do
      expect(room.valid_vote_point?("null")).to be true
    end

    it "is false if point is not 'null'" do
      expect(room.valid_vote_point?("wut")).to be false
    end

    it "is true if point is part of point values" do
      Room::DEFAULT_POINT_VALUES.each do |point|
        expect(room.valid_vote_point?(point)).to be true
      end
    end

    it "is false if point is not default point values" do
      expect(room.valid_vote_point?('10')).to be false
    end
  end

  describe "#slug!" do
    it "generates slug before create" do
      room = Room.create(name: 'test slug')
      expect(room.slug).to be_present
    end

    it "re-generates slug if room with slug exists" do
      room_1 = Room.create(name: 'test slug')
      room_2 = Room.create(name: 'test slug')
      expect(room_2.slug).to be_present
      expect(room_2.slug).not_to eq room_1.slug
    end
  end

  describe "#creator" do
    it "shows user creates the room based on created_by" do
      user = User.create(email: 'a@a.com', password: 'password')
      room = Room.create(name: 'test', created_by: user.id)
      expect(room.creator).to eq user
    end
  end

  describe "#sort_point_values" do
    it "sorts point values everytime before room saved" do
      room.name = 'test'
      room.pv = %w(40 3 20 8 13).join(',')
      room.save!
      expect(room.pv).to eq %w(3 8 13 20 40).join(',')
    end
  end

  describe "#timer_interval" do
    it "returns timer interval in seconds when timer set" do
      room.timer = 1
      expect(room.timer_interval).to be 60
    end

    it "returns 0 when timer not set" do
      room.timer = nil
      expect(room.timer_interval).to be 0
    end
  end

  describe "#grouped_stories" do
    let!(:story_1) { Story.create(link: "link_1", room_id: 1) }
    let!(:story_2) { Story.create(link: "link_2", room_id: 1) }
    let!(:story_3) { Story.create(link: "link_3", room_id: 1, point: 3) }

    it "returns stories grouped by whether it has point or not" do
      sleep 1
      story_2.touch
      room.id = 1
      expect(room.grouped_stories.size).to eq 2
      expect(room.grouped_stories[:groomed].size).to eq 1
      expect(room.grouped_stories[:ungroomed].size).to eq 2
      expect(room.grouped_stories[:ungroomed].first.link).to eq "link_2"
    end
  end

  describe "#time_duration" do
    let!(:story_1) { Story.create(link: "link_1", room_id: 1) }
    let!(:story_2) { Story.create(link: "link_2", room_id: 1) }

    it "returns time duration" do
      room.id = 1
      UserStoryPoint.create(user_id: 1, story_id: story_1.id, points: 1)
      sleep 1
      UserStoryPoint.create(user_id: 1, story_id: story_2.id, points: 3)
      expect(room.time_duration).to eq 1.0
    end
  end
end
