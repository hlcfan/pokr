require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  controller do
    def after_sign_in_path_for(resource)
      super resource
    end

    def after_sign_out_path_for(resource)
      super resource
    end
  end

  describe "After sigin-in" do
    it "sets user id and redirects to previous url" do
      allow(controller).to receive(:current_user) { double(:current_user, id: 999) }
      allow(controller.session).to receive(:[]) { "/previous-url" }
      expect(controller.after_sign_in_path_for(nil)).to eq("/previous-url")
    end

    it "sets user id and redirects to home page if no previous url" do
      allow(controller).to receive(:current_user) { double(:current_user, id: 999) }
      expect(controller.after_sign_in_path_for(nil)).to eq("/")
    end
  end

  describe "After sigin-out" do
    it "redirects to the home page" do
      expect(controller.after_sign_out_path_for(nil)).to eq("/")
    end
  end

end
