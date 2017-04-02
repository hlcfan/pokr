require 'rails_helper'

RSpec.describe RoomRepository do
  subject(:repo) { RoomRepository.new }

  describe "#new_entity" do
    it "initialize a room object if bulk import enabled" do
      room_params = {
        name: "test",
        bulk: "true",
        bulk_links: "link1\r\nlink2\r\nlink3"
      }
      room = repo.new_entity(room_params)

      expect(room.stories.map(&:link)).to eq ["link1", "link2", "link3"]
    end

    it "initialize a room object if bulk import not enabled" do
      room_params = {
        name: "test"
      }
      room = repo.new_entity(room_params)

      expect(room.name).to eq "test"
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
      expect(room.moderator_ids_string).to eq "#{bob.id}-#{bob.name}"
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
      room = repo.update_entity room, new_room_params
      room = Room.find room.id

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
  end
end