require 'rails_helper'

RSpec.describe RoomsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Room. As you add validations to Room, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: "room name", timer: 1, pv: "1,3,5,13", created_by: User.first.id, moderator_ids: "", stories_attributes: { 0 => { link: "http://jira.com/123" } } }
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
    it "redirects to dashboard page if signed in" do
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

    it "renders room show template" do
      room = Room.create! valid_attributes
      get :show, params: {:id => room.slug}, session: valid_session
      expect(response).to render_template("show")
    end

    it "renders async room show template if async room" do
      room = Room.create! valid_attributes.merge(style: Room::LEAFLET_STYLE)
      get :show, params: {:id => room.slug}, session: valid_session
      expect(response).to render_template("leaflets/show")
    end

    it "redirects to screen page if not logged in" do
      room = Room.create! valid_attributes
      allow(controller).to receive(:current_user) { nil }
      get :show, params: {:id => room.slug}, session: valid_session
      expect(response).to redirect_to screen_room_path(room.slug)
    end

    it "returns Excel file if request format is xlsx" do
      room = Room.create! valid_attributes
      story = room.stories.first
      get :show, params: {id: room.slug}, session: valid_session, format: :xlsx
      expect(response.header["Content-Disposition"]).to eq("attachment; filename=room-name.xlsx")
    end

    it "returns Excel file with at most 30 chars as filename" do
      room = Room.create! valid_attributes.merge(name: "...", slug: "slug-here-12345678909876543212345678900987654321")
      room.update(slug: "slug-hereslug-here-12345678909876543212345678900987654321")
      story = room.stories.first
      get :show, params: {id: room.slug}, session: valid_session, format: :xlsx
      expect(response.header["Content-Disposition"]).to eq("attachment; filename=slug-hereslug-here-12345678909.xlsx")
    end

    it "returns Excel file with worksheet name equals 'Estimation'" do
      room = Room.create! valid_attributes.merge(name: "2018/01/01")
      story = room.stories.first
      get :show, params: {id: room.slug}, session: valid_session, format: :xlsx
      expect(response.header["Content-Disposition"]).to eq("attachment; filename=2018-01-01.xlsx")
    end

    it "redirects to room view page if moderator of async room" do
      room = Room.create! valid_attributes.merge(name: "async room", style: Room::LEAFLET_STYLE)
      UserRoom.create(user_id: User.find_by(email: "a@a.com").id, room_id: room.id, role: UserRoom::MODERATOR)

      get :show, params: {id: room.slug}, session: valid_session
      expect(response).to redirect_to(view_room_path(room.slug))
    end

    context "if room is up to 10 participants for non premium moderator" do
      it "redirects back to dashboard page if signed in" do
        moderator = User.find_by email: "a@a.com"
        room = Room.create! valid_attributes.merge(created_by: moderator.id)
        user = nil
        1.upto(10).each do
          begin
            user = User.create(email: "a-#{SecureRandom.rand(50)}@pokrex.com", password: "password")
            UserRoom.create(user_id: user.id, room_id: room.id)
          rescue
            retry
          end
        end
        allow(controller.current_user).to receive(:id) { 999 }
        get :show, params: {:id => room.slug}, session: valid_session

        expect(response).to redirect_to dashboard_index_path
        expect(flash[:error]).to eq("Non-premium moderator can only create room with 10 participants at most, please tell your moderator to be our premium member.")

        allow(controller.current_user).to receive(:id) { user.id }
        get :show, params: {:id => room.slug}, session: valid_session
        expect(response).to render_template("show")
      end
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

      it "redirects to billing page if creating async room without premium privilege" do
        post :create, params: {:room => valid_attributes.merge(style: Room::LEAFLET_STYLE)}, session: valid_session
        expect(response).to redirect_to billing_path
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
      let(:moderator) { User.create(name: "Mod", email: "mod.r@ator", password: "password") }
      let(:new_attributes) {
        { name: "another name", scheme: "fibonacci", pv: "13,8,1,5", moderator_ids: "#{moderator.id}-#{moderator.name}" }
      }

      it "updates the requested room" do
        room = Room.create! valid_attributes
        put :update, params: {:id => room.slug, :room => new_attributes}, session: valid_session
        room.reload
        expect(room.name).to eq "another name"
        expect(room.pv).to eq "1,5,8,13"
        expect(room.moderator_ids_ary).to eq [moderator.id]
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
    before do
      allow(controller.current_user).to receive(:id) { 999 }
    end

    it "destroys the requested room" do
      room = Room.create! valid_attributes.merge(created_by: 999)
      expect {
        delete :destroy, params: {:id => room.slug}, session: valid_session
      }.to change{Room.available.count}.by(-1)
    end

    it "redirects to the rooms list" do
      room = Room.create! valid_attributes.merge(created_by: 999)
      delete :destroy, params: {:id => room.slug}, session: valid_session
      expect(response).to redirect_to(rooms_url)
    end

    it "renders corresponding js" do
      room = Room.create! valid_attributes.merge(created_by: 999)
      delete :destroy, params: {:id => room.slug}, session: valid_session, format: :js
      expect(response).to render_template("rooms/destroy")
    end

    it "renders nothing if room is not created by current user" do
      room = Room.create! valid_attributes
      delete :destroy, params: {:id => room.slug}, session: valid_session, format: :js
      expect(response.body).to be_blank
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
      expect(Room.last.updated_at.iso8601(6)).to eq room.updated_at.iso8601(6)
      expect(response.status).to eq 204
    end

    it "doesnt update room status if status parameter same with room status" do
      room = Room.create! valid_attributes.merge(status: 1)
      post :set_room_status, params: {:id => room.slug, status: "open"}, session: valid_session
      expect(Room.last.updated_at.iso8601(6)).to eq room.updated_at.iso8601(6)
      expect(response.status).to eq 204
    end

  end

  describe "GET #story_list" do
    let!(:room) { Room.create! valid_attributes }
    let!(:story){ room.stories.first }

    it "gets un-groomed stories" do
      get :story_list, format: :json, params: {:id => room.slug}, session: valid_session
      expect(assigns(:stories)).to eq({ groomed: nil, ungroomed: [story] })
    end
  end

  describe "GET #user_list" do
    let!(:room) { Room.create! valid_attributes }
    let(:user) { User.find_by email: 'a@a.com' }
    let!(:user_room) { UserRoom.create user_id: user.id, room_id: room.id }

    it "gets users in room" do
      get :user_list, format: :json, params: {:id => room.slug}, session: valid_session

      expect(assigns(:users)).to eq [{
        id: user.id,
        name: user.display_name,
        display_role: user_room.display_role,
        avatar_thumb: user.letter_avatar,
        voted: false,
        points: ""
      }]
    end
  end

  describe "GET #draw_board" do
    let!(:room) { Room.create! valid_attributes }
    let!(:story){ room.stories.first }

    it "gets groomed stories" do
      story.update_attribute :point, 13
      get :draw_board, format: :json, params: {:id => room.slug}, session: valid_session
      expect(assigns(:stories)).to eq [[story.id, story.link, story.point]]
    end
  end

  describe "GET #summary" do
    it "gets room summary" do
      room = Room.create! valid_attributes
      get :summary, params: {:id => room.slug}, session: valid_session

      expect(assigns(:summaries)).to eq []
    end
  end

  describe "POST #switch_role" do
    it "switches to participant if watcher now" do
      room = Room.create! valid_attributes
      user = User.find_by email: 'a@a.com'
      user_room = UserRoom.create(user_id: user.id, room_id: room.id, role: UserRoom::WATCHER)

      expect(controller).to receive(:broadcaster).once

      post :switch_role, params: {id: room.slug, role: UserRoom::PARTICIPANT}, session: valid_session

      expect(response.status).to eq 200
      expect(UserRoom.find_by(user_id: user.id, room_id: room.id).display_role).to eq "Participant"
    end

    it "returns bad request if invalid role to switch" do
      room = Room.create! valid_attributes
      user = User.find_by email: 'a@a.com'
      user_room = UserRoom.create(user_id: user.id, room_id: room.id, role: UserRoom::WATCHER)

      expect(controller).not_to receive(:broadcaster)

      post :switch_role, params: {id: room.slug, role: "invalid_role"}, session: valid_session

      expect(response.status).to eq 400
      expect(UserRoom.find_by(user_id: user.id, room_id: room.id).display_role).to eq "Watcher"
    end

    it "returns bad request if switch to current role" do
      room = Room.create! valid_attributes
      user = User.find_by email: 'a@a.com'
      user_room = UserRoom.create(user_id: user.id, room_id: room.id, role: UserRoom::WATCHER)

      expect(controller).not_to receive(:broadcaster)

      post :switch_role, params: {id: room.slug, role: UserRoom::WATCHER}, session: valid_session

      expect(response.status).to eq 400
      expect(UserRoom.find_by(user_id: user.id, room_id: room.id).display_role).to eq "Watcher"
    end

    it "returns bad request if it's moderator" do
      room = Room.create! valid_attributes
      user = User.find_by email: 'a@a.com'
      user_room = UserRoom.create(user_id: user.id, room_id: room.id, role: UserRoom::MODERATOR)

      expect(controller).not_to receive(:broadcaster)

      post :switch_role, params: {id: room.slug, role: UserRoom::PARTICIPANT}, session: valid_session

      expect(response.status).to eq 400
      expect(UserRoom.find_by(user_id: user.id, room_id: room.id).display_role).to eq "Moderator"
    end
  end

  describe "POST #invite" do
    it "selects valid email address and deliver emails" do
      room = Room.create! valid_attributes
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      expect(RoomInvitationMailer).to receive(:invite).once { message_delivery }
      expect(message_delivery).to receive(:deliver_later)

      post :invite, params: {id: room.slug, emails: ["a@a.com", "invalid-email", "alex@localhost"]}, session: valid_session
      expect(response.status).to eq 200
    end

    it "selects valid email address and deliver emails" do
      room = Room.create! valid_attributes
      expect(RoomInvitationMailer).not_to receive(:invite)

      post :invite, params: {id: room.slug, emails: ["invalid-email", "alex@localhost"]}, session: valid_session
      expect(response.status).to eq 200
    end
  end

  describe "GET #screen" do
    it "shows screen of a room if user not logged in" do
      room = Room.create! valid_attributes
      allow(controller).to receive(:current_user) { nil }

      get :screen, params: {id: room.slug}
      expect(response).to render_template("screen")
    end

    it "redirect to room if user logged in" do
      room = Room.create! valid_attributes

      get :screen, params: {id: room.slug}
      expect(response).to redirect_to room_path(room.slug)
    end
  end

  describe "POST #screen" do
    it "creates a guest and redirect to room with username" do
      room = Room.create! valid_attributes
      allow(controller).to receive(:current_user) { nil }

      post :screen, params: {id: room.slug, username: "Bob Dylan"}

      expect(User.last.name).to eq "bob-dylan"
      expect(response).to redirect_to room_path(room.slug)
    end

    it "creates a guest and redirect to room with email address" do
      room = Room.create! valid_attributes
      allow(controller).to receive(:current_user) { nil }

      post :screen, params: {id: room.slug, username: "Bob@Dylan.com"}

      expect(User.last.name).to eq "Bob"
      expect(response).to redirect_to room_path(room.slug)
    end

    it "redirects to sign in page if input email already exists" do
      room = Room.create! valid_attributes
      allow(controller).to receive(:current_user) { nil }

      post :screen, params: {id: room.slug, username: "a@a.com"}

      expect(response).to redirect_to new_user_session_path
    end

    it "redirects to sign in page if input email is upcase already exists" do
      room = Room.create! valid_attributes
      allow(controller).to receive(:current_user) { nil }

      post :screen, params: {id: room.slug, username: "A@A.com"}

      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "#sync_status" do
    it "broadcast data" do
      room = Room.create! valid_attributes

      expect(controller).to receive(:broadcaster).once.with("rooms/room-name", {:type=>"sync", :data=>{:link=>"link", :point=>"13"}})
      post :sync_status, params: {id: room.slug, link: "link", point: 13}
      expect(response.status).to eq 200
    end
  end

  describe "#leaflet_submit" do
    it "returns bad request if no votes in params" do
      room = Room.create! valid_attributes
      post :leaflet_submit, params: { id: room.slug }
      expect(response.status).to eq 400
    end

    it "saves votes and redirect to room page if valid votes" do
      room = Room.create! valid_attributes
      story_1 = Story.create(room_id: room.id, link: "story title")
      post :leaflet_submit, params: { id: room.slug, votes: {"0" => {story_id: story_1.id, point: "13" }}}
      expect(response).to redirect_to room_path(room.slug)
    end
  end

  describe "#leaflet_view" do
    it "shows async room view page for moderator" do
      allow(controller.current_user).to receive(:id) { 999 }
      room = Room.create! valid_attributes.merge(created_by: 999)
      get :leaflet_view, params: {id: room.slug}
      expect(response).to render_template "rooms/leaflets/view"
    end

    it "redirects to asycn room show page if not moderator" do
      room = Room.create! valid_attributes.merge(created_by: 999)
      get :leaflet_view, params: {id: room.slug}
      expect(response).to redirect_to room_path(room.slug)
    end

    it "redirects to room screen page if not sign in" do
      allow(controller).to receive(:current_user) { nil }
      room = Room.create! valid_attributes
      get :leaflet_view, params: {id: room.slug}
      expect(response).to redirect_to screen_room_path(room.slug)
    end
  end

  describe "#leaflet_finalize_point" do
    it "finalizes story point for async room" do
      allow(controller.current_user).to receive(:id) { 999 }
      room = Room.create! valid_attributes.merge(created_by: 999)
      UserRoom.create(user_id: 999, room_id: room.id, role: UserRoom::MODERATOR)
      story= Story.create(room_id: room.id, link: "story title")
      user_story_point = UserStoryPoint.create(user_id: 999, story_id: story.id, points: "13")
      post :leaflet_finalize_point, params: { id: room.slug, voteId: user_story_point.encoded_id }

      expect(story.reload.point).to eq("13")
      expect(response.status).to eq 200
    end
  end
end
