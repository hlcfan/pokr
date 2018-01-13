require 'rails_helper'

RSpec.describe ProfileController, type: :controller do

  describe "GET #show" do
    context "when user logged in" do
      login_user
      it "sets user and renders user profile page" do
        get :show
        expect(assigns(:user)).to eq(User.last)
      end
    end

    context "when user does not logged in" do
      describe "GET #show" do
        it "redirects user to sign in page" do
          get :show
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe "PATCH #update" do
    context "when user logged in" do
      login_user
      it "successfully updates user profile, only name" do
        patch :update, params: { user: { name: 'name-to-be', email: 'b@b.com', avatar_file_name: 'avatar.png', avatar_content_type: 'image/jpeg' } }
        expect(User.last.name).to eq "name-to-be"
        expect(User.last.email).to eq "a@a.com"
        expect(response).to redirect_to profile_path
      end

      it "renders show template if updating failed" do
        allow_any_instance_of(User).to receive(:update_attributes) { false }
        patch :update, params: { user: { name: 'name-to-be', email: 'b@b.com' } }
        expect(User.last.name).to eq "alex"
        expect(response).to render_template "show"
      end

      it "allows to update email and removes guest user identifier if guest user" do
        @request.session[:guest_user_id] = "what-ever-id"
        patch :update, params: { user: { name: 'name-to-be', email: 'b@b.com', avatar_file_name: 'avatar.png', avatar_content_type: 'image/jpeg' } }
        expect(User.last.email).to eq "b@b.com"
        expect(response).to redirect_to profile_path
        expect(session[:guest_user_id]).to be_nil
      end
    end

    context "when user does not logged in" do
      it "redirects user to sign in page" do
        patch :update, params: { user: { name: 'name-to-be', email: 'b@b.com' } }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #update_password" do
    context "when user logged in" do
      login_user
      it "successfully updates user password" do
        patch :update_password, params: { user: { current_password: 'password', password: 'password-update', 'password_confirmation': 'password-update' } }
        expect(User.last.valid_password?("password-update")).to be true
        expect(response).to redirect_to profile_path
      end

      it "renders show template if password_confirmation does not match" do
        patch :update_password, params: { user: { current_password: 'password', password: 'password-update', 'password_confirmation': 'password-upda' } }
        expect(response).to render_template "show"
      end

      it "renders show template if updating failed" do
        allow_any_instance_of(User).to receive(:update) { false }
        patch :update_password, params: { user: { current_password: 'password', password: 'password-update', 'password_confirmation': 'password-update' } }
        expect(response).to render_template "show"
      end

      it "updates user password without verifying current password if guest user" do
        @request.session[:guest_user_id] = "what-ever-id"
        patch :update_password, params: { user: { password: 'password-update', 'password_confirmation': 'password-update' } }
        expect(User.last.valid_password?("password-update")).to be true
        expect(response).to redirect_to profile_path
      end
    end

    context "when user does not logged in" do
      it "redirects user to sign in page" do
        patch :update_password, params: { user: { current_password: 'password', password: 'password-update', 'password_confirmation': 'password-update' } }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
