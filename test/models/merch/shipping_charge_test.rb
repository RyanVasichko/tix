require "test_helper"

class Merch::ShippingChargeTest < ActiveSupport::TestCase
  test "for_weight returns the correct shipping charge" do
    FactoryBot.create(:merch_shipping_charge, weight: 1, price: 5)
    FactoryBot.create(:merch_shipping_charge, weight: 2, price: 10)

    assert_equal 5, Merch::ShippingCharge.for_weight(0)
    assert_equal 5, Merch::ShippingCharge.for_weight(1)
    assert_equal 10, Merch::ShippingCharge.for_weight(2)
  end
end
