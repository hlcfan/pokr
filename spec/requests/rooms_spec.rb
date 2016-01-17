require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  describe "GET /rooms" do
    it "works! (now write some real specs)" do
      get rooms_path
      expect(response).to have_http_status(200)
    end
  end
end
