require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  describe "GET #index" do
    context "when user signed in" do
      login_user

      it "shows user joined teams" do
        get :index
        expect(response).to render_template "index"
      end
    end

    context "when user does not signed in" do
      render_views

      it "redirects to sign in page" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
