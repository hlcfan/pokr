require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  login_user
  describe "#create" do
    it "creates order by month and redirects to paypal gateway" do
      allow(PaymentService).to receive(:create) {
        double(:payment_service, links: [ double(:link, method: "REDIRECT", href: "paypal_gateway") ], error: nil, id: "payment-id")
      }
      post :create, params: { billing: { month: "2" } }
      expect(response).to redirect_to "paypal_gateway"
      expect(Order.first.payment_id).to eq("payment-id")
    end

    it "redirects to billing page if payment error" do
      allow(PaymentService).to receive(:create) {
        double(:payment_service, links: [ double(:link, method: "REDIRECT", href: "paypal_gateway") ], error: "some error happens")
      }
      post :create, params: { billing: { month: "2" } }
      expect(response).to redirect_to billing_path
      expect(flash[:error]).to eq("some error happens")
    end
  end

  describe "#success" do
    it "redirects to billing path once gets called if success payment returned from paypal" do
      user = User.find_by email: "a@a.com"
      Order.create(user_id: user.id, payment_id: "payment-id", quantity: 2)
      payment_id = "payment-id"
      payer_id = "payer-id"
      allow(PaymentService).to receive(:execute_payment).with({payment_id: payment_id, payer_id: payer_id}) {
        double(:payment_service, success?: true)
      }
      get :success, params: { paymentId: payment_id, PayerID: payer_id }
      expect(response).to redirect_to billing_path
    end

    it "redirects to billing path with error message gets called if success payment returned from paypal" do
      user = User.find_by email: "a@a.com"
      order = Order.create(user_id: user.id, payment_id: "payment-id", quantity: 2)
      payment_id = "payment-id"
      payer_id = "payer-id"
      allow(PaymentService).to receive(:execute_payment).with({payment_id: payment_id, payer_id: payer_id}) {
        double(:payment_service, success?: false, error: "Paypal internal error")
      }
      expect(Rails.logger).to receive(:error).with("Payment failure, order id: #{order.id}, error: Paypal internal error").once
      get :success, params: { paymentId: payment_id, PayerID: payer_id }
      expect(response).to redirect_to billing_path
      expect(flash[:error]).to eq("Payment failed :-|")
    end
  end

  describe "#cancel" do
    it "gets called if cancel the payment from paypal gateway" do
      get :cancel
      expect(response).to redirect_to billing_path
    end
  end

  describe "#hook" do
    before {
      User.create(email: "a@a.com", password: "password")
    }

    it "creates Order successfully if subscription paid" do
      params = {
        alert_name: "subscription_payment_succeeded",
        plan_name: "Monthly premium payment",
        checkout_id: "checkout-id",
        coupon: "coupon-code",
        currency: "USD",
        email: "a@a.com",
        order_id: "order-id",
        payment_method: "paypal",
        quantity: "1",
        receipt_url: "http://receipt_url.com/receipt.html",
        subscription_id: "subscription-id",
        unit_price: "7"
      }
      expect {
        post :hook, params: params
      }.to change { Order.count }.by(1)
    end

    it "creates failed order if subscription paid failure" do
      params = {
        alert_name: "subscription_payment_failed",
        checkout_id: "checkout-id",
        currency: "USD",
        email: "a@a.com",
        quantity: "1",
        subscription_id: "subscription-id",
        unit_price: "7"
      }

      expect {
        post :hook, params: params
      }.to change { Order.count }.by(1)
    end

    it "creates subscription if subscription created successfully" do
      params = {
        alert_name: "subscription_created",
        cancel_url: "http://url-to-cancel",
        update_url: "http://url-to-update",
        email: "a@a.com",
        subscription_id: "subscription-id",
        subcription_plan_id: "subscription-plan-id"
      }

      expect {
        post :hook, params: params
      }.to change { Subscription.count }.by(1)
    end

    it "creates cancelled subscription if subscription cancelled" do
      params = {
        alert_name: "subscription_cancelled",
        email: "a@a.com",
        subscription_id: "subscription-id",
        subcription_plan_id: "subscription-plan-id",
        cancellation_effective_date: "2018-11-13 05:56:27"
      }

      expect {
        post :hook, params: params
      }.to change { Subscription.count }.by(1)
    end
  end
end
