require 'rails_helper'

RSpec.describe SiteController, type: :controller do
  
  describe "GET #about" do
    it "renders about page" do
      get :about
      expect(response).to render_template "about"
    end
  end
end