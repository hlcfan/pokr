require 'rails_helper'

RSpec.describe SchemesController, type: :controller do

  let(:valid_attributes) {
    { name: "test scheme", user_id: User.first.id, points: ["1", "2", "3"] }
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SchemesController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  login_user

  describe "GET #index" do
    it "assigns all schemes as @schemes" do
      scheme = Scheme.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:schemes).size).to eq(1)
    end
  end

  describe "GET #new" do
    it "assigns a new scheme as @scheme" do
      get :new, params: {}, session: valid_session
      expect(assigns(:scheme)).to be_a_new(Scheme)
    end

    it "redirects to billing page if non premium member and already has a scheme created" do
      scheme = Scheme.create! valid_attributes.merge(name: "scheme 2")
      get :new, session: valid_session
      expect(response).to redirect_to(billing_path)
      expect(flash[:error]).to eq("Non-premium user cannot create more than 1 custom schemes.")
    end

    it "renders new page if premium member" do
      Scheme.create! valid_attributes.merge(name: "scheme 1")
      Scheme.create! valid_attributes.merge(name: "scheme 2")
      allow(controller.current_user).to receive(:premium_expiration) { Time.now + 10.days }
      get :new, session: valid_session
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    it "assigns the requested scheme as @scheme" do
      scheme = Scheme.create! valid_attributes
      get :edit, params: {:id => scheme.slug}, session: valid_session
      expect(assigns(:scheme)).to eq(scheme)
    end

    it "redirects to billing page if non premium member and already has a scheme created" do
      scheme = Scheme.create! valid_attributes.merge(name: "scheme 2")
      get :edit, params: {:id => scheme.slug}, session: valid_session
      expect(response).to redirect_to(billing_path)
      expect(flash[:error]).to eq("Non-premium user cannot create more than 1 custom schemes.")
    end

    it "renders edit page if user is premium member" do
      Scheme.create! valid_attributes.merge(name: "scheme 1")
      scheme = Scheme.create! valid_attributes.merge(name: "scheme 2")
      allow(controller.current_user).to receive(:premium_expiration) { Time.now + 10.days }
      get :edit, params: {:id => scheme.slug}, session: valid_session
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Scheme" do
        expect {
          post :create, params: {:scheme => valid_attributes}, session: valid_session
        }.to change(Scheme, :count).by(1)
      end

      it "assigns a newly created scheme as @scheme" do
        post :create, params: {:scheme => valid_attributes}, session: valid_session
        expect(assigns(:scheme)).to be_a(Scheme)
        expect(assigns(:scheme)).to be_persisted
      end

      it "redirects to the scheme list page" do
        post :create, params: {:scheme => valid_attributes}, session: valid_session
        expect(response).to redirect_to(schemes_path)
      end

      it "redirects to billing page if non premium member and already has a scheme created" do
        scheme = Scheme.create! valid_attributes.merge(name: "scheme 1")
        post :create, params: {:scheme => valid_attributes}, session: valid_session
        expect(response).to redirect_to(billing_path)
        expect(flash[:error]).to eq("Non-premium user cannot create more than 1 custom schemes.")
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved scheme as @scheme" do
        post :create, params: {:scheme => invalid_attributes}, session: valid_session
        expect(assigns(:scheme)).to be_a_new(Scheme)
      end

      it "re-renders the 'new' template" do
        post :create, params: {:scheme => invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "another name", user_id: 2, points: ["a", "b", "c"] }
      }

      it "updates the requested scheme" do
        scheme = Scheme.create! valid_attributes
        put :update, params: {:id => scheme.slug, :scheme => new_attributes}, session: valid_session
        scheme.reload
        expect(scheme.name).to eq "another name"
        expect(scheme.points).to eq ["a", "b", "c"]
      end

      it "assigns the requested scheme as @scheme" do
        scheme = Scheme.create! valid_attributes
        put :update, params: {:id => scheme.slug, :scheme => valid_attributes}, session: valid_session
        expect(assigns(:scheme)).to eq(scheme)
      end

      it "redirects to the scheme" do
        scheme = Scheme.create! valid_attributes
        put :update, params: {:id => scheme.slug, :scheme => valid_attributes}, session: valid_session
        expect(response).to redirect_to(schemes_path)
      end
    end

    context "with invalid params" do
      it "assigns the scheme as @scheme" do
        scheme = Scheme.create! valid_attributes
        put :update, params: {:id => scheme.slug, :scheme => invalid_attributes}, session: valid_session
        expect(assigns(:scheme)).to eq(scheme)
      end

      it "re-renders the 'edit' template" do
        scheme = Scheme.create! valid_attributes
        put :update, params: {:id => scheme.slug, :scheme => invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(controller.current_user).to receive(:id) { 999 }
    end

    it "destroys the requested scheme" do
      scheme = Scheme.create! valid_attributes.merge(user_id: 999)
      expect {
        delete :destroy, params: {:id => scheme.slug}, session: valid_session
      }.to change{Scheme.count}.by(-1)
    end

    it "redirects to the schemes list" do
      scheme = Scheme.create! valid_attributes.merge(user_id: 999)
      delete :destroy, params: {:id => scheme.slug}, session: valid_session
      expect(response).to redirect_to(schemes_url)
    end

    it "renders corresponding js" do
      scheme = Scheme.create! valid_attributes
      delete :destroy, params: {:id => scheme.slug}, session: valid_session, format: :js
      expect(response).to render_template("schemes/destroy")
    end

    it "renders nothing if scheme is not created by current user" do
      scheme = Scheme.create! valid_attributes
      delete :destroy, params: {:id => scheme.slug}, session: valid_session, format: :js
      expect(response.body).to be_blank
    end
  end

end
