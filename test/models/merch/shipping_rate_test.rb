require "test_helper"

class Merch::ShippingRateTest < ActiveSupport::TestCase
  test "for_purchases returns the correct shipping rate" do
    FactoryBot.create(:merch_shipping_rate, weight: 1, price: 5)
    FactoryBot.create(:merch_shipping_rate, weight: 2, price: 10)

    merch = FactoryBot.create(:merch, weight: 1)
    purchase = FactoryBot.build(:order_merch_purchase, quantity: 1, purchaseable: merch)

    assert_equal 0, Merch::ShippingRate.for_purchases([])
    assert_equal 5, Merch::ShippingRate.for_purchases([purchase])

    purchase.quantity = 2
    assert_equal 10, Merch::ShippingRate.for_purchases([purchase])
  end
end
