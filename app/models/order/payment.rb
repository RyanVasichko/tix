class Order::Payment < ApplicationRecord
  validates :amount_in_cents, presence: true
  validates :stripe_payment_method_id, presence: true
  validates :stripe_payment_intent_id, presence: true
  validates :card_brand, presence: true
  validates :card_exp_month, presence: true
  validates :card_exp_year, presence: true
  validates :card_last_4, presence: true

  has_one :order
  has_one :user, through: :order

  def process(save_payment_method = false)
    stripe_customer = order.user.stripe_customer
    payment_method = Stripe::PaymentMethod.retrieve(self.stripe_payment_method_id)
    payment_intent_params = {
      amount: amount_in_cents,
      currency: :usd,
      payment_method: self.stripe_payment_method_id,
      confirm: true,
      customer: stripe_customer.id,
      automatic_payment_methods: {
        enabled: true,
        allow_redirects: "never"
      },
      metadata: {
        order_id: order.id
      }
    }
    payment_intent_params[:setup_future_usage] = :on_session if save_payment_method

    payment_intent = Stripe::PaymentIntent.create(payment_intent_params)

    if payment_intent["status"] == "succeeded"
      update!(
        stripe_payment_intent_id: payment_intent.id,
        card_brand: payment_method.card.brand,
        card_exp_month: payment_method.card.exp_month,
        card_exp_year: payment_method.card.exp_year,
        card_last_4: payment_method.card.last4
      )
    end

    return payment_intent["status"] == "succeeded"
  end
end
