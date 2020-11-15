require 'rails_helper'

RSpec.describe OrganizationController, type: :controller do
  let(:current_user) { User.first }
  let(:valid_org_attributes) {
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

  describe "POST #switch_admin" do
    login_user

    it "returns unauthorized error if current user doesn't have organization" do
      post :switch_admin, params: {organization_id: "fake-one", uid: "fake-one"}, session: valid_session, format: "json"

      expect(response.status).to eq 401
    end

    it "returns unauthorized error if current user doesn't have permission to update role" do
      org = Organization.create(valid_org_attributes)
      user_org = UserOrganization.create(user_id: current_user.id, organization_id: org.id)

      post :switch_admin, params: {organization_id: org.uid, uid: current_user.id}, session: valid_session, format: "json"

      expect(response.status).to eq 401
    end

    it "sets admin role for target user" do
      org = Organization.create(valid_org_attributes)
      user_org1 = UserOrganization.create(user_id: current_user.id, organization_id: org.id, role: 2)
      user2 = User.create(email: "b@b.com", password: "password")
      user_org2 = UserOrganization.create({user_id: user2.id, organization_id: org.id})

      post :switch_admin, params: {organization_id: org.uid, uid: user2.uid}, session: valid_session, format: "json"

      user_org2.reload

      expect(user_org2.role).to eq(2)
      expect(response.status).to eq 204
    end

    it "unsets admin role for target user" do
      org = Organization.create(valid_org_attributes)
      user_org1 = UserOrganization.create(user_id: current_user.id, organization_id: org.id, role: 2)
      user2 = User.create(email: "b@b.com", password: "password")
      user_org2 = UserOrganization.create({user_id: user2.id, organization_id: org.id, role: 2})

      post :switch_admin, params: {organization_id: org.uid, uid: user2.uid}, session: valid_session, format: "json"

      user_org2.reload

      expect(user_org2.role).to eq(1)
      expect(response.status).to eq 204
    end

    it "return 400 if update fails" do
      org = Organization.create(valid_org_attributes)
      org2 = Organization.create(valid_org_attributes.merge({name: "another org"}))
      user_org1 = UserOrganization.create(user_id: current_user.id, organization_id: org.id, role: 2)
      user2 = User.create(email: "b@b.com", password: "password")
      user_org2 = UserOrganization.create({user_id: user2.id, organization_id: org2.id, role: 2})

      post :switch_admin, params: {organization_id: org2.uid, uid: user2.uid}, session: valid_session, format: "json"

      expect(response.status).to eq 400
    end
  end
end
