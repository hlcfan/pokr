require 'rails_helper'

RSpec.describe PaymentService do

  describe ".create" do
    it "creates a paypal payment" do
      order = Order.new(name: "Monthly subscription", price: 10.00, quantity: 2, currency: "USD")
      payment = PaymentService.create order, "http://localhost:3000/payments/success", "http://localhost:3000/payments/cancel"
      allow_any_instance_of(PayPal::SDK::REST::Payment).to receive(:create)

      expect(payment.transactions.first.amount.total).to eq("20.00")
      expect(payment.error).to be_nil
      expect(payment.state).to eq("created")
    end
  end

  describe ".execute_payment" do
    it "executes the payment via paypal" do
      order = Order.new(name: "Monthly subscription", price: 10.00, quantity: 2, currency: "USD")
      payment_1 = PaymentService.create order, "http://localhost:3000/payments/success", "http://localhost:3000/payments/cancel"
      allow_any_instance_of(PayPal::SDK::REST::Payment).to receive(:create)

      allow(PayPal::SDK::REST::Payment).to receive(:find) { payment_1 }
      allow_any_instance_of(PayPal::SDK::REST::Payment).to receive(:execute)
      payment_2 = PaymentService.execute_payment(payment_id: payment_1.id, payer_id: "payer-id")

      expect(payment_2.error).to be_nil
      expect(payment_2.state).to eq("created")
    end
  end
end
