Stripe.api_key = Rails.application.credentials.stripe.api_key unless ENV.fetch("SECRET_KEY_BASE_DUMMY", 0) == "1"
