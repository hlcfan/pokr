require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  
  describe "GET #index" do
    context "when user signed in" do
      login_user

      it "redirects user to dashboard if user signed in" do
        get :index
        expect(response).to redirect_to dashboard_index_path
      end
    end

    context "when user does not signed in" do
      render_views
      it "renders home page" do
        get :index
        expect(response.body).to match /<h1>/
        expect(response).to render_template "index", layout: false
      end
    end
  end

  describe "GET #sign_up" do
    it "redirects user to registration page and set cookies" do
      get :sign_up, params: { email: 'a@a.com' }
      expect(cookies[:email]).to eq "a@a.com"
      expect(response).to redirect_to new_user_registration_path
    end
  end

end
