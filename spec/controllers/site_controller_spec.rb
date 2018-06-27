require 'rails_helper'

RSpec.describe SiteController, type: :controller do

  describe "GET #about" do
    it "renders about page" do
      get :about
      expect(response).to render_template "about.en"
    end
  end

  describe "GET #faq" do
    it "renders faq page" do
      get :faq
      expect(response).to render_template "faq.en"
    end
  end

  describe "GET #donate" do
    it "renders donate page" do
      get :donate
      expect(assigns[:donations]).to be_kind_of(Array)
      expect(response).to render_template "donate.en"
    end
  end

  describe "GET #apps" do
    it "renders apps page" do
      get :apps
      expect(response).to render_template "apps"
    end
  end
end
