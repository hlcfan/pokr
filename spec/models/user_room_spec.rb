require 'rails_helper'

RSpec.describe UserRoom, type: :model do
  subject(:user_room) { UserRoom.new }

  describe "#moderator?" do
    it "is true if role equals 0" do
      user_room.role = 0
      expect(user_room.moderator?).to be true
    end

    it "is false if role isnt equals 0" do
      user_room.role = 1
      expect(user_room.moderator?).to be false
    end
  end

  describe "#participant?" do
    it "is true if role equals 1" do
      user_room.role = 1
      expect(user_room.participant?).to be true
    end

    it "is false if role isnt equals 1" do
      user_room.role = 0
      expect(user_room.participant?).to be false
    end
  end

  describe "#watcher?" do
    it "is true if role equals 2" do
      user_room.role = 2
      expect(user_room.watcher?).to be true
    end

    it "is false if role isnt equals 2" do
      user_room.role = 0
      expect(user_room.watcher?).to be false
    end
  end

  describe "#display_role" do
    it "is Moderator when role equals 0" do
      user_room.role = 0
      expect(user_room.display_role).to eq "Moderator"
    end
    it "is Participant when role equals 1" do
      user_room.role = 1
      expect(user_room.display_role).to eq "Participant"
    end
    it "is Watcher when role not equals 0 or 1" do
      user_room.role = nil
      expect(user_room.display_role).to eq "Watcher"
    end
  end

  describe ".find_by_with_cache" do
    let(:conditions) { { user_id: 1, room_id: 1 } }

    it "calls Rails.cache.fetch" do
      expect(Rails.cache).to receive(:fetch).with("user_room:1:1")
      UserRoom.find_by_with_cache user_id: 1, room_id: 1
    end

    it "bypass cache and find in DB when cannot find in cache" do
      Rails.cache.clear
      expect(UserRoom).to receive(:find_by).with(conditions)
      UserRoom.find_by_with_cache user_id: 1, room_id: 1
    end
  end
end
