Stripe.api_key = Rails.application.credentials.stripe.api_key

StripeEvent.signing_secret = Rails.application.credentials.stripe.signing_secret

StripeEvent.configure do |events|
  events.subscribe "payment_intent.succeeded" do |event|
    if event.metadata.order_id
      # If there isn't an order for this payment intent, something went wrong during
      # ordering and we need to refund the payment
      EnsureStripePaymentIntentAttachedToOrderJob.set(wait: 30.minutes).perform_later(
        order_id: event.metadata.order_id,
        payment_intent_id: event.data.object.id
      )
    end
  end
end
