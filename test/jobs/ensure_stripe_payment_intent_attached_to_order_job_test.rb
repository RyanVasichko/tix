require 'test_helper'
require 'minitest/mock'

class EnsureStripePaymentIntentAttachedToOrderJobTest < ActiveJob::TestCase
  test 'refund should be initiated when order does not exist with given payment intent' do
    Order.delete_all

    mock = Minitest::Mock.new
    mock.expect :call, true, [{payment_intent_id: 'pi_67890'}]

    Stripe::Refund.stub :create, mock do
      EnsureStripePaymentIntentAttachedToOrderJob.perform_now(order_id: 123, payment_intent_id: 'pi_67890')
    end

    mock.verify
  end

  test 'refund should not be initiated when order exists with given payment intent' do
    skip "Not working"
    order = Order.create!(user: users(:user))
    order.create_payment!(stripe_payment_intent_id: 'pi_67890')

    mock = Minitest::Mock.new

    Stripe::Refund.stub :create, mock do
      EnsureStripePaymentIntentAttachedToOrderJob.perform_now(order_id: order.id, payment_intent_id: 'pi_67890')
    end
  end
end
