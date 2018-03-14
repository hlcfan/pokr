require 'rails_helper'

RSpec.describe TypeaheadController, type: :controller do

  describe "#index" do
    login_user

    it "returns 400 if no query provided" do
      get :index
      expect(response.status).to eq 400
    end

    it "returns grouped typeahead data" do
      room = Room.create(name: "room name")
      user = User.find_by(email: "a@a.com")
      story = Story.create(link: "related room story", desc: "description", room_id: room.id, point: "13")
      UserRoom.create(user_id: user.id, room_id: room.id)
      UserStoryPoint.create(user_id: user.id, story_id: story.id, points: "13")
      PgSearch::Multisearch.rebuild(Room)
      PgSearch::Multisearch.rebuild(Story)
      get :index, format: :json, params: {query: "room"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)[0]["title"]).to eq("related room story")
      expect(JSON.parse(response.body)[1]["title"]).to eq("room name")
    end
  end
end
