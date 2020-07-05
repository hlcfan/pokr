require 'rails_helper'

RSpec.describe RoomRepository do
  subject(:repo) { RoomRepository.new }

  describe "#new_entity" do
    it "initializes a room object if bulk import enabled" do
      room_params = {
        name: "test",
        bulk: "true",
        bulk_links: "link1\tdescription\r\nlink2\tanother description\r\nlink3|third description and forth"
      }
      room = repo.new_entity(room_params)

      expect(room.stories.map(&:link)).to eq ["link1", "link2", "link3"]
      expect(room.stories.map(&:desc)).to eq ["description", "another description", "third description and forth"]
      expect(room.stories.map(&:sequence)).to eq [1, 2, 3]
    end

    it "initializes a room object if bulk import not enabled" do
      room_params = {
        name: "test"
      }
      room = repo.new_entity(room_params)

      expect(room.name).to eq "test"
    end

    it "initializes a room object with stories with sequence" do
      room_params = {
        name: "test",
        stories_attributes: {
          "0"=>{"link"=>"113", "desc"=>"", "_destroy"=>"false"},
          "1"=>{"link"=>"22", "desc"=>"", "_destroy"=>"false"}
        }
      }
      room = repo.new_entity(room_params)
      expect(room.stories.map(&:sequence)).to eq [1, 2]
    end
  end

  describe "#save" do
    it "saves the room and along with moderators" do
      alex = User.create(name: "Alex", email: "a@a.com", password: "password")
      bob = User.create(name: "Bob", email: "b@b.com", password: "password")
      room_params = {
        name: "test",
        created_by: alex.id,
        moderator_ids: "#{bob.id}-#{bob.name}"
      }
      room = repo.new_entity(room_params)
      room = repo.save room

      expect(room.persisted?).to be_truthy
      expect(room.moderator_ids_ary).to eq [bob.id]
    end
  end

  describe "#update_entity" do
    it "updates the room and along with moderators if adding more moderators" do
      alex = User.create(name: "Alex", email: "a@a.com", password: "password")
      bob = User.create(name: "Bob", email: "b@b.com", password: "password")
      room_params = {
        name: "test",
        created_by: alex.id,
        moderator_ids: "#{bob.id}-#{bob.name}"
      }

      catlin = User.create(name: "Catlin", email: "c@c.com", password: "password")
      drake = User.create(name: "Drake", email: "d@d.com", password: "password")
      new_room_params = {
        name: "updated-name",
        moderator_ids: "#{bob.id}-#{bob.name},#{catlin.id}-#{catlin.name},#{drake.id}-#{drake.name}"
      }
      room = repo.new_entity(room_params)
      room = repo.save room
      # Make sure it updates existing participant to moderator
      UserRoom.create(user_id: catlin.id, room_id: room.id)
      room = repo.update_entity room, new_room_params
      room = Room.find room.id

      expect(room.status).to be_nil
      expect(room.name).to eq "updated-name"
      expect(room.moderator_ids_ary).to eq [bob.id, catlin.id, drake.id]
    end

    it "updates the room and along with moderators if removing moderators" do
      alex = User.create(name: "Alex", email: "a@a.com", password: "password")
      bob = User.create(name: "Bob", email: "b@b.com", password: "password")
      catlin = User.create(name: "Catlin", email: "c@c.com", password: "password")
      room_params = {
        name: "test",
        created_by: alex.id,
        moderator_ids: "#{bob.id}-#{bob.name},#{catlin.id}-#{catlin.name}"
      }

      new_room_params = {
        name: "updated-name",
        moderator_ids: "#{bob.id}-#{bob.name}"
      }
      room = repo.new_entity(room_params)
      room = repo.save room
      room = repo.update_entity room, new_room_params
      room = Room.find room.id

      expect(room.name).to eq "updated-name"
      expect(room.moderator_ids_ary).to eq [bob.id]
    end

    it "updates the room and along with moderators if changing moderators" do
      alex = User.create(name: "Alex", email: "a@a.com", password: "password")
      bob = User.create(name: "Bob", email: "b@b.com", password: "password")
      catlin = User.create(name: "Catlin", email: "c@c.com", password: "password")
      room_params = {
        name: "test",
        created_by: alex.id,
        moderator_ids: "#{bob.id}-#{bob.name}"
      }

      new_room_params = {
        name: "updated-name",
        moderator_ids: "#{catlin.id}-#{catlin.name}"
      }
      room = repo.new_entity(room_params)
      room = repo.save room
      room = repo.update_entity room, new_room_params
      room = Room.find room.id

      expect(room.name).to eq "updated-name"
      expect(room.moderator_ids_ary).to eq [catlin.id]
    end

    it "updates room stories with sequence" do
      room_params = {
        name: "test",
        created_by: 1,
        stories_attributes: {
          "0"=>{"link"=>"first", "desc"=>"", "_destroy"=>"false"},
          "1"=>{"link"=>"second", "desc"=>"", "_destroy"=>"false"}
        }
      }
      room = repo.new_entity(room_params)
      room = repo.save room

      first_story = Story.find_by link: "first"
      second_story = Story.find_by link: "second"

      new_room_params = {
        name: "test",
        stories_attributes: {
          "0" => { "id" => first_story.id, "link" => "first", "desc" => "", "_destroy" => "false"},
          "3" => { "link" => "third", "desc" => "", "_destroy" => "false" },
          "1" => { "id" => second_story.id, "link" => "second", "desc" => "", "_destroy" => "false"}
        }
      }
      room = repo.update_entity room, new_room_params

      expect(room.stories.map(&:link)).to eq ["first", "third", "second"]
    end

    it "updates room stories with sequence when bulk edit" do
      room_params = {
        name: "test",
        created_by: 1,
        stories_attributes: {
          "0"=>{"link"=>"first", "desc"=>"", "_destroy"=>"false"},
          "1"=>{"link"=>"second", "desc"=>"", "_destroy"=>"false"}
        }
      }
      room = repo.new_entity(room_params)
      room = repo.save room

      first_story = Story.find_by link: "first"
      second_story = Story.find_by link: "second"

      new_room_params = {
        name: "test",
        bulk: "true",
        bulk_links: "first1\tdescription1|##{first_story.uid}#\r\nsecond2\tanother description|##{second_story.uid}#\r\nnew story|new description"
      }
      room = repo.update_entity room, new_room_params

      expect(room.stories.map(&:link)).to eq ["first1", "second2", "new story"]
      expect(room.stories.map(&:desc)).to eq ["description1", "another description", "new description"]
    end
  end
end
