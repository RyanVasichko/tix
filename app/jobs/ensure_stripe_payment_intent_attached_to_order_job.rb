class EnsureStripePaymentIntentAttachedToOrderJob < ApplicationJob
  queue_as :default

  def perform(order_id:, payment_intent_id:)
    return if Order.joins(:payment).exists?(id: order_id, payment: { stripe_payment_intent_id: payment_intent_id })

    Stripe::Refund.create({ payment_intent_id: payment_intent_id })
  end
end
