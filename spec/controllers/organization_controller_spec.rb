require 'rails_helper'

RSpec.describe OrganizationController, type: :controller do
  let(:current_user) { User.first }
  let(:valid_attributes) {
    { name: "Org name", created_by: current_user.id }
  }

  let(:valid_session) { {} }

  login_user

  describe "GET #show" do
    it "assigns the requested org as @org" do
      org = Organization.create! valid_attributes
      UserOrganization.create! user_id: current_user.id,  organization_id: org.id
      get :show, params: {}, session: valid_session

      assigned_org = assigns(:org)

      expect(assigned_org.users).to eq([current_user])
      expect(assigned_org).to eq(org)
    end

    it "renders organization show template" do
      org = Organization.create! valid_attributes
      UserOrganization.create! user_id: current_user.id,  organization_id: org.id
      get :show, params: {}, session: valid_session

      expect(response).to render_template("show")
    end
  end
end
