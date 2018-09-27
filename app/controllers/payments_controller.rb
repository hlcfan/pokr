class PaymentsController < ApplicationController

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
      # set transaction status to success and save some data
      @order.update_attribute(:status, Order::SUCCESS)
      current_user.expand_premium_expiration @order.quantity * 1.month
      render plain: "Paid successfully!"
    else
      # show error message
      render plain: "payment failure"
    end
  end

  def cancel
    redirect_back(fallback_location: root_path)
  end

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
    else
      order = order.update_attribute :payment_id, payment.id
      redirection_url = payment.links.find{|v| v.method == "REDIRECT" }.href
      redirect_to redirection_url and return
    end
  end
end

