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
        total: number_with_precision(order.price, precision: 2),
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
end
