require 'rails_helper'

RSpec.describe Guest do

  before do
    class FakesController < ApplicationController
    end
  end

  after { Object.send :remove_const, :FakesController }
  let(:ccontroller) { FakesController.new }

  before(:all) { Struct.new("User", :id, :email) }

  describe "#current_or_guest_user" do
    it "returns current user if user is signed in and no guest user" do
      allow(ccontroller).to receive(:session) { {} }
      allow(ccontroller).to receive(:current_user) { Struct::User.new(1, "a@a.com") }
      expect(ccontroller.current_or_guest_user.email).to eq("a@a.com")
    end

    it "returns current user if user is signed in and removes guest user id" do
      allow(ccontroller).to receive(:session) { {guest_user_id: 9999}  }
      allow(ccontroller).to receive(:current_user) { Struct::User.new(1, "b@b.com") }
      # expect(ccontroller.session).to receive(:[]=) #{ nil }
      # Workround: by testing User.find to test session[:guest_user_id] = nil
      # expect(User).to receive(:find)
      expect(ccontroller.current_or_guest_user.email).to eq("b@b.com")
    end

    it "returns guest user if no user logged in" do
      allow(ccontroller).to receive(:session) { {} }
      # allow(ccontroller).to receive(:cookies) { {} }
      allow(ccontroller).to receive(:params) { { username: "Bob" } }
      allow(ccontroller).to receive(:current_user) { nil }
      expect(ccontroller.current_or_guest_user.email).not_to be_nil
    end

    it "returns guest user if user inputs email" do
      allow(ccontroller).to receive(:session) { {}  }
      # allow(ccontroller).to receive(:cookies) { {} }
      allow(ccontroller).to receive(:params) { {username: "email@email.com"} }
      allow(ccontroller).to receive(:current_user) { nil }
      ccontroller.current_or_guest_user
      expect(User.last.email).to eq("email@email.com")
    end
  end

  describe "#guest_user?" do
    it "returns true if session[:guest_user_id] exists" do
      allow(ccontroller).to receive(:session) { { guest_user_id: 1 } }
      expect(ccontroller.guest_user?).to be true
    end

    it "returns false if session[:guest_user_id] not exists" do
      allow(ccontroller).to receive(:session) { { } }
      expect(ccontroller.guest_user?).to be false
    end
  end

  describe "#remove_guest_user" do
    it "removes guest_user_id from session" do
      allow(ccontroller).to receive(:session) { { guest_user_id: 1 } }
      expect(ccontroller.remove_guest_user).to be_nil
    end
  end
end
