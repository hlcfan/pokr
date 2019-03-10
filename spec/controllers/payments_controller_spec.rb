require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe "#hook" do
    before {
      User.create(email: "a@a.com", password: "password")
    }

    it "creates Order successfully if subscription paid" do
      params = {
        alert_name:      "subscription_payment_succeeded",
        plan_name:       "Monthly premium payment",
        checkout_id:     "checkout-id",
        coupon:          "coupon-code",
        currency:        "USD",
        email:           "a@a.com",
        order_id:        "order-id",
        payment_method:  "paypal",
        quantity:        "1",
        receipt_url:     "http://receipt_url.com/receipt.html",
        subscription_id: "subscription-id",
        unit_price:      "7"
      }
      expect {
        post :hook, params: params
      }.to change { Order.count }.by(1)
    end

    it "creates failed order if subscription paid failure" do
      params = {
        alert_name:      "subscription_payment_failed",
        checkout_id:     "checkout-id",
        currency:        "USD",
        email:           "a@a.com",
        quantity:        "1",
        subscription_id: "subscription-id",
        unit_price:      "7"
      }

      expect {
        post :hook, params: params
      }.to change { Order.count }.by(1)
    end

    it "creates subscription if subscription created successfully" do
      params = {
        alert_name:          "subscription_created",
        cancel_url:          "http://url-to-cancel",
        update_url:          "http://url-to-update",
        email:               "a@a.com",
        subscription_id:     "subscription-id",
        subcription_plan_id: "subscription-plan-id"
      }

      expect {
        post :hook, params: params
      }.to change { Subscription.count }.by(1)
    end

    it "creates cancelled subscription if subscription cancelled" do
      params = {
        alert_name:                  "subscription_cancelled",
        email:                       "a@a.com",
        subscription_id:             "subscription-id",
        subcription_plan_id:         "subscription-plan-id",
        cancellation_effective_date: "2018-11-13 05:56:27"
      }

      expect {
        post :hook, params: params
      }.to change { Subscription.count }.by(1)
    end
  end
end
