class PaymentsController < ApplicationController

  protect_from_forgery except: :hook

  def hook
    case params[:alert_name]
    when "subscription_payment_succeeded"
      order = Order.create! success_params
      order.user.expand_premium_expiration order.quantity * 1.month
    when "subscription_payment_failed"
      Order.create! fail_params
    when "subscription_created"
      Subscription.create! subscription_creation_params
    when "subscription_cancelled"
      Subscription.create! subscription_cancellation_params
    end

    head :ok
  end

  private

  def order_params
    paddle_params = params.slice(:checkout_id, :coupon, :currency, :email, :order_id, :payment_method, :plan_name, :quantity, :receipt_url, :subscription_id, :unit_price)

    user = User.find_by(email: paddle_params[:email])

    {
      name:            paddle_params[:plan_name],
      quantity:        paddle_params[:quantity],
      price:           paddle_params[:unit_price],
      user_id:         user.id,
      currency:        paddle_params[:currency],
      payment_id:      paddle_params[:payment_id],
      coupon:          paddle_params[:coupon],
      checkout_id:     paddle_params[:order_id],
      payment_method:  paddle_params[:payment_method],
      receipt_url:     paddle_params[:receipt_url],
      subscription_id: paddle_params[:subscription_id]
    }
  end

  def success_params
    order_params.merge(status: Order::SUCCESS)
  end

  def fail_params
    order_params.merge({status: Order::FAILED, name: "Pokrex premium subscription"})
  end

  def subscription_creation_params
    paddle_params = params.slice(:cancel_url, :email, :subscription_id, :subscription_plan_id, :update_url)
    user = User.find_by(email: paddle_params[:email])

    {
      user_id:              user.id,
      status:               Subscription::ACTIVE,
      subscription_id:      paddle_params[:subscription_id],
      subscription_plan_id: paddle_params[:subscription_plan_id],
      update_url:           paddle_params[:update_url],
      cancel_url:           paddle_params[:cancel_url]
    }
  end

  def subscription_cancellation_params
    paddle_params = params.slice(:email, :subscription_id, :subscription_plan_id, :cancellation_effective_date)
    user = User.find_by(email: paddle_params[:email])

    {
      user_id:                     user.id,
      status:                      Subscription::DELETED,
      subscription_id:             paddle_params[:subscription_id],
      subscription_plan_id:        paddle_params[:subscription_plan_id],
      cancellation_effective_date: paddle_params[:cancellation_effective_date]
    }
  end
end

