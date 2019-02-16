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
      room.style = 1
      expect(room.state).to eq "not-open"
    end

    it "defautls to not-open if free style" do
      room.status = nil
      expect(room.state).to eq "not-open"
    end
  end

  describe "#display_state" do
    it "is Finished if state equals draw" do
      room.status = 2
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
      expect(room.groomed_stories.map(&:first)).to eq [story_2.id, story_3.id]
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
  end

  describe "#point_values" do
    it "returns default fibonacci scheme if pv is blank" do
      expect(room.point_values).to eq Scheme.default_schemes["fibonacci"][:points]
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
      Scheme.default_schemes["fibonacci"][:points].each do |point|
        expect(room.valid_vote_point?(point)).to be true
      end
    end

    it "is false if point is not default point values" do
      expect(room.valid_vote_point?('10')).to be false
    end
  end

  describe "#slug!" do
    it "generates slug when latin chars" do
      room = Room.create(name: "test slug")
      expect(room.slug).to eq "test-slug"
      expect(room.slug).to be_present
    end

    it "re-generates slug if room with slug exists" do
      room_1 = Room.create(name: 'test slug')
      room_2 = Room.create(name: 'test slug')
      expect(room_2.slug).to be_present
      expect(room_2.slug).not_to eq room_1.slug
    end

    it "translates name when Chinese" do
      room = Room.create(name: '测试')
      expect(room.slug).to eq "ce-shi"
      expect(room.slug).to be_present
    end

    it "translates name when name with date" do
      room = Room.create(name: 'test 2012/12/12')
      expect(room.slug).to eq "test-2012-12-12"
      expect(room.slug).to be_present
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
    it "sorts point values everytime before room saved according to scheme" do
      room.name = 'test'
      room.pv = %w(40 3 21 8 13).join(',')
      room.save!
      expect(room.pv).to eq %w(3 8 13 21 40).join(',')
    end

    it "sorts point values if less point values to be sorted" do
      room.name = 'test'
      room.pv = %w(40 3 8 13).join(',')
      room.save!
      expect(room.pv).to eq %w(3 8 13 40).join(',')
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
      story_2.touch(:created_at)
      room.id = 1
      expect(room.grouped_stories.size).to eq 2
      expect(room.grouped_stories[:groomed].size).to eq 1
      expect(room.grouped_stories[:ungroomed].size).to eq 2
      expect(room.grouped_stories[:ungroomed].first.link).to eq "link_1"
    end
  end

  # describe "#time_duration" do
  #   let!(:story_1) { Story.create(link: "link_1", room_id: 1) }
  #   let!(:story_2) { Story.create(link: "link_2", room_id: 1) }

  #   it "returns time duration" do
  #     room.id = 1
  #     UserStoryPoint.create(user_id: 1, story_id: story_1.id, points: 1)
  #     sleep 0.1
  #     UserStoryPoint.create(user_id: 1, story_id: story_2.id, points: 3)
  #     expect(room.time_duration).to eq 1.0
  #   end
  # end

  describe "#free_style?" do
    it "is true if style equals 1" do
      room.style = 1
      expect(room.free_style?).to be_truthy
    end

    it "is false if style doesn't equals 1" do
      expect(room.free_style?).to be_falsy
    end
  end

  describe "#async_mode?" do
    it "is true if style equals 2" do
      room.style = 2
      expect(room.async_mode?).to be_truthy
    end

    it "is false if style doesn't equals 2" do
      expect(room.async_mode?).to be_falsy
    end
  end

  describe "#user_list" do
    context "when sync=true" do
      it "lists users with points and vote status in a room if sync=true" do
        user1 = User.create(email: 'a@a.com', password: 'password')
        user2 = User.create(email: 'b@b.com', password: 'password')
        room = Room.create(name: 'test slug')
        UserRoom.create(user_id: user2.id, room_id: room.id)
        sleep 0.1
        UserRoom.create(user_id: user1.id, room_id: room.id)
        story = Story.create(link: "link_1", room_id: room.id)
        UserStoryPoint.create(user_id: user1.id, story_id: story.id, points: 10)
        UserStoryPoint.create(user_id: user2.id, story_id: story.id, points: 13)

        expect(room.user_list({sync: "true"}).map{|u|u[:points]}).to eq(["13", "10"])
        expect(room.user_list.map{|u|u[:voted]}).to eq([true, true])
      end
    end

    context "when sync=false" do
      it "lists users without points, with vote status in a room if someone voted" do
        user1 = User.create(email: 'a@a.com', password: 'password')
        user2 = User.create(email: 'b@b.com', password: 'password')
        room = Room.create(name: 'test slug')
        UserRoom.create(user_id: user2.id, room_id: room.id)
        sleep 0.1
        UserRoom.create(user_id: user1.id, room_id: room.id)
        story = Story.create(link: "link_1", room_id: room.id)
        UserStoryPoint.create(user_id: user1.id, story_id: story.id, points: 10)
        UserStoryPoint.create(user_id: user2.id, story_id: story.id, points: 13)

        expect(room.user_list.map{|u|u[:id]}).to eq([user2.id, user1.id])
        expect(room.user_list.map{|u|u[:voted]}).to eq([true, true])
      end

      it "lists users without points and without vote status in a room if no one voted" do
        user1 = User.create(email: 'a@a.com', password: 'password')
        user2 = User.create(email: 'b@b.com', password: 'password')
        room = Room.create(name: 'test slug')
        UserRoom.create(user_id: user2.id, room_id: room.id, role: 0)
        UserRoom.create(user_id: user1.id, room_id: room.id, role: 2)

        expect(room.user_list.map{|u|u[:id]}).to eq([user2.id, user1.id])
        expect(room.user_list.map{|u|u[:voted]}).to eq([false, false])
      end
    end

    it "lists users in a room partitioned by user role" do
      user1 = User.create(email: 'a@a.com', password: 'password')
      user2 = User.create(email: 'b@b.com', password: 'password')
      watcher = User.create(email: 'w@tcher.com', password: 'password')
      room = Room.create(name: 'test slug')
      UserRoom.create(user_id: user2.id, room_id: room.id, role: 0)
      UserRoom.create(user_id: watcher.id, room_id: room.id, role: 2)
      sleep 0.1
      UserRoom.create(user_id: user1.id, room_id: room.id, role: 1)

      expect(room.user_list.map{|u|u[:id]}).to eq([user2.id, user1.id, watcher.id])
    end
  end

  describe "#moderator_hash" do
    it "returns moderator id/name as hash if has moderators" do
      allow(room).to receive(:moderators) { [[1, "Alex"], [2, "Bob"]] }

      expect(room.moderator_hash).to eq [{value: 1, name: "Alex"}, {value: 2, name: "Bob"}]
    end

    it "returns nil if no moderators" do
      allow(room).to receive(:moderators) { [] }

      expect(room.moderator_hash).to eq nil
    end
  end

  describe "#moderator_ids_ary" do
    it "returns moderator names in string if has moderators" do
      allow(room).to receive(:moderators) { [[1, "Alex"], [2, "Bob"]] }

      expect(room.moderator_ids_ary).to eq [1,2]
    end

    it "returns empty array if no moderators" do
      allow(room).to receive(:moderators) { [] }

      expect(room.moderator_ids_ary).to eq []
    end
  end

  describe "#moderators" do
    it "returns moderators without creator" do
      creator = User.create(email: "c@c.com", password: "password")
      moderator = User.create(email: 'b@b.com', password: 'password')
      participant = User.create(email: 'p@p.com', password: 'password')
      room.name = "test"
      room.created_by = creator.id
      room.save!
      UserRoom.create(room_id: room.id, user_id: moderator.id, role: UserRoom::MODERATOR)
      UserRoom.create(room_id: room.id, user_id: participant.id)

      expect(room.send(:moderators)).to eq [[moderator.id, moderator.name]]
    end
  end

  describe "#summary" do
    it "gets room summary" do
      room = Room.create(name: "test slug")
      story = Story.create(link: "link_1", room_id: room.id, desc: "description")
      story.update_attribute :point, 13
      user_alex = User.create email: 'a@a.com', password: 'password'
      user_bob = User.create(email: 'b@b.com', password: 'password')
      UserRoom.create(user_id: user_alex.id, room_id: room.id, role: UserRoom::PARTICIPANT)
      UserRoom.create(user_id: user_bob.id, room_id: room.id, role: UserRoom::PARTICIPANT)
      vote_alex = UserStoryPoint.create(user_id: user_alex.id, story_id: story.id, points: 13)
      vote_bob = UserStoryPoint.create(user_id: user_bob.id, story_id: story.id, points: 8)

      expect(room.summary).to eq [{
        id: story.id,
        link: story.link,
        desc: story.desc,
        point: story.point,
        individuals: [
          {
            user_id: user_alex.id,
            user_point: "13",
            user_name: user_alex.display_name,
            user_avatar: user_alex.letter_avatar,
            user_story_point_id: vote_alex.encoded_id,
            user_story_point_finalized: nil,
            user_story_point_comment: nil
          },
          {
            user_id: user_bob.id,
            user_point: "8",
            user_name: user_bob.display_name,
            user_avatar: user_bob.letter_avatar,
            user_story_point_id: vote_bob.encoded_id,
            user_story_point_finalized: nil,
            user_story_point_comment: nil
          }
        ]
      }]
    end
  end

  describe "#leaflet_votes_summary" do
    it "returns leaflet summary" do
      room = Room.create(name: "test slug")
      story = Story.create(link: "link_1", room_id: room.id, desc: "description")
      sleep 0.5
      story2 = Story.create(link: "link_2", room_id: room.id, desc: "description 2")
      story.update_attribute :point, 13
      user_alex = User.create email: 'a@a.com', password: 'password'
      user_bob = User.create(email: 'b@b.com', password: 'password')
      UserRoom.create(user_id: user_alex.id, room_id: room.id, role: UserRoom::PARTICIPANT)
      UserRoom.create(user_id: user_bob.id, room_id: room.id, role: UserRoom::PARTICIPANT)
      vote_alex = UserStoryPoint.create(user_id: user_alex.id, story_id: story.id, points: 13)
      vote_bob = UserStoryPoint.create(user_id: user_bob.id, story_id: story.id, points: 8)

      expect(room.leaflet_votes_summary).to eq(
        [
          {
            :id => story2.id, :link=>story2.link, :desc=>story2.desc, :point=>nil, :individuals=>[]
          },
          {
            :id    => story.id,
            :link  => story.link,
            :desc  => story.desc,
            :point => story.point,
            :individuals=> [
              {
                :user_id                    => user_alex.id,
                :user_point                 => "13",
                :user_name                  => user_alex.display_name,
                :user_avatar                => user_alex.letter_avatar,
                :user_story_point_id        => vote_alex.encoded_id,
                :user_story_point_finalized => nil,
                :user_story_point_comment   => nil
              },
              {
                :user_id                    => user_bob.id,
                :user_point                 => "8",
                :user_name                  => user_bob.display_name,
                :user_avatar                => user_bob.letter_avatar,
                :user_story_point_id        => vote_bob.encoded_id,
                :user_story_point_finalized => nil,
                :user_story_point_comment   => nil
              }
            ]
          }
        ]
      )
    end
  end

  describe "#update_duration" do
    let(:the_room) { Room.create(name: "test slug") }

    it "updates duration" do
      room = the_room.update_duration(3.3)
      expect(room.duration).to eq 3.3
    end

    it "does not update duration if smaller duration" do
      the_room.duration = 10.3
      expect(the_room.update_duration(3.3)).to be_nil
    end
  end

  describe "#pv_for_form" do
    it "returns string joined by ','" do
      expect(room.pv_for_form).to eq "0,1,2,3,5,8,13,21,40,100,?,coffee"
    end
  end

  describe "#default_values" do
    it "returns default scheme and pv" do
      expect(room.scheme).to eq "fibonacci"
      expect(room.pv).to eq "0,1,2,3,5,8,13,21,40,100,?,coffee"
    end
  end

  describe "#soft_delete" do
    it "soft deletes room and belonging stories" do
      room.name = "soft delete"
      room.save!
      story = room.stories.create(link: "soft delete link")
      room.soft_delete

      expect(room.reload.discarded_at).to eq story.reload.discarded_at
    end
  end

  describe "#as_json" do
    it "returns only name and created_at" do
      room.name = "room name"
      room.created_at = "2048-12-12"
      expect(room.as_json).to eq({"name"=>"room name", "created_at"=>"Sat, 12 Dec 2048 00:00:00 UTC +00:00"})
    end
  end

  describe "#related_to_user?" do
    it "returns true if user joined the room" do
      room.name = "room name"
      room.save!
      user = User.create(email: 'a@a.com', password: 'password')
      UserRoom.create(user_id: user.id, room_id: room.id, role: UserRoom::PARTICIPANT)
      PgSearch::Multisearch.rebuild(Room)
      expect(room.related_to_user?(user.id)).to be true
    end

    it "returns false if user ever never joined the room" do
      room.name = "room name"
      room.save!
      user = User.create(email: 'a@a.com', password: 'password')
      PgSearch::Multisearch.rebuild(Room)
      expect(room.related_to_user?(user.id)).to be false
    end
  end

  describe "#async_votes_hash" do
    it "returns votes hash of an user" do
      room = Room.create(name: "test slug")
      user = User.create(email: 'a@a.com', password: 'password')
      story = Story.create(link: "link_1", room_id: room.id)
      vote = UserStoryPoint.create(user_id: user.id, story_id: story.id, points: "13", comment: "My comments")

      expect(room.async_votes_hash(user.id)).to eq({story.id => { :point => "13", :comment => "My comments" }})
    end
  end

  describe "#closed?" do
    it "returns true if room is closed" do
      room.status = 2
      expect(room.closed?).to be true
    end

    it "returns false if room is not closed" do
      room.status = 1
      expect(room.closed?).to be false
    end
  end
end
