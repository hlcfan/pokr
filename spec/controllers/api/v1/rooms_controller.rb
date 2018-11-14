require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do

  render_views
  # This should return the minimal set of attributes required to create a valid
  # Room. As you add validations to Room, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: "room name", timer: 1, pv: "1,3,5,13", created_by: User.first.id, moderator_ids: "", stories_attributes: { 0 => { link: "http://jira.com/123" } } }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RoomsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  login_user
  describe "GET #index" do
    it "lists user's participated rooms" do
      room = Room.create! valid_attributes.merge(created_at: "2018-11-13 11:11:11")
      UserRoom.create!(user_id: User.first.id, room_id: room.id)
      get :index, params: { format: "json" }, session: valid_session

      expect(response.body).to eq("{\"success\":\"true\",\"data\":[{\"id\":\"room-name\",\"name\":\"room name\",\"create_date\":\"November 13, 2018 11:11\",\"link\":\"http://test.host/rooms/room-name\"}]}")
      expect(response).to render_template("rooms/index")
    end
  end

  describe "show" do
    it "lists groomed tickets of a given room" do
      room = Room.create! valid_attributes
      story1 = Story.create(room_id: room.id, link: "ticket 1", point: "12")
      story2 = Story.create(room_id: room.id, link: "ticket 2")
      get :show, params: { id: room.slug, format: "json" }, session: valid_session

      expect(response.body).to eq("{\"success\":\"true\",\"data\":{\"ticket 1\":{\"point\":\"12\"}}}")
    end
  end
end
