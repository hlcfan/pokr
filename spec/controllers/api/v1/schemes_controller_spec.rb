require 'rails_helper'

RSpec.describe Api::V1::SchemesController, type: :controller do

  render_views
  # This should return the minimal set of attributes required to create a valid
  # Room. As you add validations to Room, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      name: "scheme name",
      user_id: User.first.id,
      points: ["1", "2", "3"]
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RoomsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  login_user
  describe "GET #index" do
    it "lists all schemes including custom schemes" do
      Scheme.create!(valid_attributes)
      get :index, params: { format: "json" }
      expect(response.body).to eq("{\"success\":\"true\",\"data\":{\"Fibonacci\":\"fibonacci\",\"0-8\":\"0-8\",\"XS-XXL\":\"xs-xxl\",\"Hours\":\"hours\",\"scheme-name\":\"scheme name\"}}")
    end
  end
end
