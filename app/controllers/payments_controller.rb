class PaymentsController < ApplicationController

  def create
    month = params[:billing][:month]
    order = Order.new({
      name: "Monthly premium payment",
      quantity: month,
      price: 7,
      user_id: current_user.id,
      currency: "USD",
      status: Order::INITIAL
    })

    payment = PaymentService.create order, success_payments_url, canceled_payments_url

    if payment.error.present?
      payment.error  # Error Hash
      redirect_to billing_path, flash: { error: payment.error }
    else
      order = order.update_attribute :payment_id, payment.id
      redirection_url = payment.links.find{|v| v.method == "REDIRECT" }.href
      redirect_to redirection_url
    end
  end

  def success
    payment_id = params.fetch(:paymentId, nil)
    if payment_id.present?
      @order = ::Order.find_by(payment_id: payment_id)
      @payment = PaymentService.execute_payment(
        payment_id: payment_id,
        payer_id: params[:PayerID]
      )
    end

    if @order && @payment && @payment.success?
      @order.update_attribute(:status, Order::SUCCESS)
      current_user.expand_premium_expiration @order.quantity * 1.month
      redirect_to billing_path, flash: { success: "Thanks for your payment, we'll work hard to serve you well 🤗" }
    else
      Rails.logger.error("Payment failure, order id: #{@order.id}, error: #{@payment.error}")
      redirect_to billing_path, flash: { error: "Payment failed :-|" }
    end
  end

  def cancel
    redirect_to billing_path, flash: { info: "Payment canceled." }
  end

end

