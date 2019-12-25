require 'rails_helper'

RSpec.describe RetrosController, type: :controller do

  let(:valid_attributes) {
    { name: "retro name", scheme_uid: "www" }
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  let(:retro) { Retro.create! valid_attributes }

  let(:valid_session) { {} }
  login_user

  describe "GET #new" do
    it "assigns a new retro as @retro" do
      get :new, params: {}, session: valid_session
      expect(assigns(:retro)).to be_a_new(Retro)
      expect(assigns(:retro).retro_scheme_id).to eq(-1)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Retro" do
        expect {
          post :create, params: {:retro => valid_attributes}, session: valid_session
        }.to change(Retro, :count).by(1)
      end

      it "assigns a newly created retro as @retro" do
        post :create, params: {:retro => valid_attributes}, session: valid_session
        expect(assigns(:retro)).to be_a(Retro)
        expect(assigns(:retro)).to be_persisted
      end

      # it "redirects to the created retro" do
      #   post :create, params: {:retro => valid_attributes}, session: valid_session
      #   expect(response).to redirect_to(retro_path(Retro.last.slug))
      # end

      # it "redirects to billing page if creating async retro without premium privilege" do
      #   post :create, params: {:retro => valid_attributes.merge(style: Retro::LEAFLET_STYLE)}, session: valid_session
      #   expect(response).to redirect_to billing_path
      # end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved retro as @retro" do
        post :create, params: {:retro => invalid_attributes}, session: valid_session
        expect(assigns(:retro)).to be_a_new(Retro)
      end

      it "re-renders the 'new' template" do
        post :create, params: {:retro => invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end
end

