require 'rails_helper'

RSpec.describe RoomsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Room. As you add validations to Room, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: "room name", pv: "1,3,5,13", stories_attributes: [{ link: "http://jira.com/123" }]}
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RoomsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  login_user
  describe "GET #index" do
    it "assigns all rooms as @rooms" do
      room = Room.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to redirect_to dashboard_index_path
    end
  end

  describe "GET #show" do
    it "assigns the requested room as @room" do
      room = Room.create! valid_attributes
      get :show, params: {:id => room.slug}, session: valid_session
      expect(assigns(:room)).to eq(room)
    end
  end

  describe "GET #new" do
    it "assigns a new room as @room" do
      get :new, params: {}, session: valid_session
      expect(assigns(:room)).to be_a_new(Room)
    end
  end

  describe "GET #edit" do
    it "assigns the requested room as @room" do
      room = Room.create! valid_attributes
      get :edit, params: {:id => room.slug}, session: valid_session
      expect(assigns(:room)).to eq(room)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Room" do
        expect {
          post :create, params: {:room => valid_attributes}, session: valid_session
        }.to change(Room, :count).by(1)
      end

      it "assigns a newly created room as @room" do
        post :create, params: {:room => valid_attributes}, session: valid_session
        expect(assigns(:room)).to be_a(Room)
        expect(assigns(:room)).to be_persisted
      end

      it "redirects to the created room" do
        post :create, params: {:room => valid_attributes}, session: valid_session
        expect(response).to redirect_to(room_path(Room.last.slug))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved room as @room" do
        post :create, params: {:room => invalid_attributes}, session: valid_session
        expect(assigns(:room)).to be_a_new(Room)
      end

      it "re-renders the 'new' template" do
        post :create, params: {:room => invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "another name", pv: "13,8,1,5" }
      }

      it "updates the requested room" do
        room = Room.create! valid_attributes
        put :update, params: {:id => room.slug, :room => new_attributes}, session: valid_session
        room.reload
        expect(room.name).to eq "another name"
        expect(room.pv).to eq "1,5,8,13"
      end

      it "assigns the requested room as @room" do
        room = Room.create! valid_attributes
        put :update, params: {:id => room.slug, :room => valid_attributes}, session: valid_session
        expect(assigns(:room)).to eq(room)
      end

      it "redirects to the room" do
        room = Room.create! valid_attributes
        put :update, params: {:id => room.slug, :room => valid_attributes}, session: valid_session
        expect(response).to redirect_to(room_path(room.slug))
      end
    end

    context "with invalid params" do
      it "assigns the room as @room" do
        room = Room.create! valid_attributes
        put :update, params: {:id => room.slug, :room => invalid_attributes}, session: valid_session
        expect(assigns(:room)).to eq(room)
      end

      it "re-renders the 'edit' template" do
        room = Room.create! valid_attributes
        put :update, params: {:id => room.slug, :room => invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested room" do
      room = Room.create! valid_attributes
      expect {
        delete :destroy, params: {:id => room.slug}, session: valid_session
      }.to change(Room, :count).by(-1)
    end

    it "redirects to the rooms list" do
      room = Room.create! valid_attributes
      delete :destroy, params: {:id => room.slug}, session: valid_session
      expect(response).to redirect_to(rooms_url)
    end
  end

  describe "POST #set_room_status" do
    it "updates room status if status changed" do
      room = Room.create! valid_attributes
      post :set_room_status, params: {:id => room.slug, status: "open"}, session: valid_session
      expect(Room.last.status).to eq Room::OPEN
      expect(Room.last.status).to eq 1
      expect(response.status).to eq 204
    end

    it "doesnt update room status if status parameter is invalid" do
      room = Room.create! valid_attributes
      post :set_room_status, params: {:id => room.slug, status: "wut"}, session: valid_session
      expect(Room.last.status).to eq nil
      expect(Room.last.updated_at).to eq room.updated_at
      expect(response.status).to eq 204
    end

    it "doesnt update room status if status parameter same with room status" do
      room = Room.create! valid_attributes.merge(status: 1)
      post :set_room_status, params: {:id => room.slug, status: "open"}, session: valid_session
      expect(Room.last.updated_at).to eq room.updated_at
      expect(response.status).to eq 204
    end

  end

  describe "GET #story_list" do
    let!(:room) { Room.create! valid_attributes }
    let!(:story){ room.stories.first }

    it "gets un-groomed stories" do
      get :story_list, format: :json, params: {:id => room.slug}, session: valid_session
      expect(assigns(:stories)).to eq [story]
    end
  end

  describe "GET #user_list" do
    let!(:room) { Room.create! valid_attributes }
    let(:user) { User.find_by email: 'a@a.com' }
    let!(:user_room) { UserRoom.create user_id: user.id, room_id: room.id }

    it "gets users in room" do
      get :user_list, format: :json, params: {:id => room.slug}, session: valid_session

      expect(assigns(:users)).to eq [user]
    end
  end

  describe "GET #draw_board" do
    let!(:room) { Room.create! valid_attributes }
    let!(:story){ room.stories.first }

    it "gets groomed stories" do
      story.update_attribute :point, 13
      get :draw_board, format: :json, params: {:id => room.slug}, session: valid_session
      expect(assigns(:stories)).to eq [story]
    end
  end
end
