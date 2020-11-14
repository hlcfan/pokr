require 'rails_helper'

RSpec.describe OrganizationController, type: :controller do
  let(:current_user) { User.first }
  let(:valid_attributes) {
    { name: "Org name", created_by: current_user.id }
  }

  let(:valid_session) { {} }

  describe "GET #show" do
    context "when user signed in" do
      login_user

      it "renders organization show template" do
        get :show, params: {}, session: valid_session

        expect(assigns(:org)).to be_nil
        expect(response).to render_template("show")
      end
    end

    context "when user does not signed in" do
      render_views

      it "redirects to sign in page" do
        get :show, params: {}, session: valid_session

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
