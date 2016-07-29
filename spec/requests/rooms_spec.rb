require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  describe "GET /rooms" do
    it "redirects user to sign in page if not logged in" do
      get rooms_path
      expect(response).to have_http_status(302)
    end
  end
end
