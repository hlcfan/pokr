class PaymentsController < ApplicationController

  def new
    # Build Payment object
    order = Order.create({
      name: "Monthly",
      quantity: 1,
      price: 5,
      user_id: current_user.id,
      currency: "USD",
      status: Order::INITIAL
    })

    payment = PaymentService.create order, success_payments_url, canceled_payments_url
    if payment.error.present?
      @payment.error  # Error Hash
    else
      order = order.update_attribute :payment_id, payment.id
      redirection_url = payment.links.find{|v| v.method == "REDIRECT" }.href
      redirect_to redirection_url and return
    end
  end

  def success
    payment_id = params.fetch(:paymentId, nil)
    if payment_id.present?
      @order = ::Order.find_by(payment_id: payment_id)
        # token: payment_id,
      @payment = execute_payment(
        payment_id: payment_id,
        payer_id: params[:PayerID]
      )
    end

    binding.pry
    if @order && @payment && @payment.success?
      # set transaction status to success and save some data
      @order.update_attribute(:status, 1)
      render plain: "Paid successfully!"
    else
      # show error message
      render plain: "payment failure" and return
    end
  end

  def cancel
  end

  def execute_payment(payment_id:, payer_id:)
    payment = PayPal::SDK::REST::Payment.find(payment_id)
    payment.execute(payer_id: payer_id) unless payment.error

    payment
  end
end

