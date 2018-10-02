require 'rails_helper'

RSpec.describe Order, type: :model do
  subject(:order) { Order.new(name: "Monthly subscription") }
  describe "#friendly_status" do
    it "returns Canceled if payment isn't done" do
      order.status = Order::INITIAL
      expect(order.friendly_status).to eq("Canceled")
    end

    it "returns Failed if payment failed" do
      order.status = Order::FAILED
      expect(order.friendly_status).to eq("Failed")
    end

    it "returns Success if payment succeed" do
      order.status = Order::SUCCESS
      expect(order.friendly_status).to eq("Success")
    end

    it "returns Unknown as order default status" do
      expect(order.friendly_status).to eq("Unknown")
    end
  end

  describe "associations" do
    it "belongs to user" do
      expect(Order.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end
end
