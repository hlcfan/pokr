require 'rails_helper'

RSpec.describe TypeaheadController, type: :controller do

  describe "#index" do
    it "returns empty head if no query provided" do
      get :index
      expect(response.status).to eq 400
    end

    it "returns grouped typeahead data" do
      room = Room.create(name: "room name")
      story = Story.create(link: "related room story", desc: "description", room_id: room.id, point: "13")
      PgSearch::Multisearch.rebuild(Room)
      PgSearch::Multisearch.rebuild(Story)
      get :index, format: :json, params: {query: "room"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)["Room"][0]["name"]).to eq("room name")
      expect(JSON.parse(response.body)["Story"][0]["link"]).to eq("related room story")
    end
  end
end
