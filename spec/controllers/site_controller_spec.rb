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
    it "redirects to extensions page" do
      get :apps
      expect(response).to redirect_to "/extensions"
      expect(response.status).to eq(301)
    end
  end

  describe "GET #extensions" do
    it "renders extensions page" do
      get :extensions
      expect(response).to render_template "extensions"
    end
  end

  describe "GET pricing_page" do
    it "renders pricing page" do
      get :pricing_page
      expect(response).to render_template "pricing_page"
    end
  end
end
