require 'rails_helper'

RSpec.describe UserRoom, type: :model do
  subject(:user_room) { UserRoom.new }

  describe "#owner?" do
    it "is true if role equals 0" do
      user_room.role = 0
      expect(user_room.owner?).to be true
    end
  end

  describe "#display_role" do
    it "is Owner when role equals 0" do
      user_room.role = 0
      expect(user_room.display_role).to eq "Owner"
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
      expect(Rails.cache).to receive(:fetch).with([conditions])
      UserRoom.find_by_with_cache conditions
    end

    it "bypass cache and find in DB when cannot find in cache" do
      Rails.cache.clear
      expect(UserRoom).to receive(:find_by).with(conditions)
      UserRoom.find_by_with_cache conditions
    end
  end
end
