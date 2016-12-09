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
end
