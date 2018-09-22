module PaymentService

  extend ActionView::Helpers::NumberHelper

  # def initialize(params)
  #   @transaction = params[:transaction]
  #   @return_url = params[:return_url]
  #   @cancel_url = params[:cancel_url]
  #   @money = params[:money] || "5"
  #   @currency = @transaction.currency || "USD"
  # end

  def self.create order, return_url, cancel_url
    payment = PayPal::SDK::REST::Payment.new({
      intent: "sale",
      payer: { payment_method: "paypal" },
      redirect_urls: { return_url: return_url, cancel_url: cancel_url },
      transactions: [
        get_item_list(order)
      ]
    })

    payment.create

    payment
  end

  def self.get_item_list order
    {
      item_list: {
        items: [
          {
            name: order.name,
            price: order.price,
            currency: order.currency,
            quantity: order.quantity
          }
        ]
      },
      amount: {
        total: number_with_precision(order.price*order.quantity, precision: 2),
        currency: order.currency,
        description: "Monthly payment for Pokrex"
      }
    }
  end

  def self.execute_payment(payment_id:, payer_id:)
    payment = PayPal::SDK::REST::Payment.find(payment_id)
    payment.execute(payer_id: payer_id) unless payment.error

    payment
  end

  def self.create_recurring_agreement order, return_url, cancel_url
    plan = create_and_active_recurring_plan(order, return_url, cancel_url)
    if plan && plan.success?
      agreement = create_agreement(plan)
    end

    (plan unless plan.success?) || agreement
  end

  def self.create_and_active_recurring_plan order, return_url, cancel_url
    plan = PayPal::SDK::REST::Plan.new(plan_param(order, return_url, cancel_url))
    plan.update(active_plan_params) if plan.create

    plan # If any error occured, the message will be saved in plan.error
  end

  private

  def self.create_agreement plan
    agreement = PayPal::SDK::REST::Agreement.new(agreement_param(plan.id))
    agreement.create
    # If any error occured, the message will be saved in agreement.error
    agreement
  end

  def self.agreement_param plan_id
    # customize you own agreement with: https://developer.paypal.com/docs/api/payments.billing-agreements#agreement_create
    {
      name: "Monthly subscription",
      description: "Monthly subscription description",
      # you can set up different start date according to the product
      # or just set it to the time right after you create this agreement.
      # In ISO8601 Format:  YYYY-MM-DDTHH:MM:SSTimeZone
      start_date: Time.now.strftime("%Y-%m-%dT%H:%M:%SZ"),
      payer: { payment_method: "paypal" },
      plan: { id: plan_id }
    }
  end

  def self.active_plan_params
    {
      op: "replace",
      value: { state: "ACTIVE" },
      path: "/"
    }
  end

  def self.plan_param order, return_url, cancel_url
    # customize your own plan parameters with:  https://developer.paypal.com/docs/api/payments.billing-plans/#plan_create
    {
      "name" => "Pokrex monthly payment",
      "description" => "Monly payment description",
      "type" => "fixed",
      "payment_definitions" => [
        {
          "name" => "Regular Payments",
          "type" => "REGULAR",
          "frequency" => "MONTH",
          "frequency_interval" => "1",
          "amount" => {
            "value" => order.price,
            "currency" => order.currency
          },
          "cycles" => "12",
          "charge_models" => [
          ]
        }
      ],
      "merchant_preferences" => {
        "setup_fee" => {
          "value" => "0",
          "currency" => "USD"
        },
        "return_url" => return_url,
        "cancel_url" => cancel_url,
        "auto_bill_amount" => "YES",
        "initial_fail_amount_action" => "CONTINUE",
        "max_fail_attempts" => "0"
      }
    }
  end
end
