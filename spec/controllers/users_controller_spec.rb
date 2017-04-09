require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  describe "GET #autocomplete" do
    context "if user logged in" do
      login_user
      it "returns users that match the query term" do
        bob = User.create(name: "Bob", email: "b@b.com", password: "password")
        get :autocomplete, params: { term: "b" }
        body = JSON.parse(response.body)

        expect(body).to eq [{"value"=>bob.id, "name"=>bob.name }]
      end

      it "renders bad request if no query passed in" do
        get :autocomplete
        expect(response.status).to eq 400
      end
    end

    context "if user logged in" do
      it "redirects user to sign in page" do
        get :autocomplete
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
