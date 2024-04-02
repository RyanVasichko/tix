require "test_helper"

class Admin::Merch::ShippingRatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
    @shipping_rate = FactoryBot.create(:merch_shipping_rate)
  end

  test "index should get index" do
    get admin_merch_shipping_rates_url
    assert_response :success
  end

  test "new should get new" do
    get new_admin_merch_shipping_rate_url, as: :turbo_stream
    assert_response :success
  end

  test "create should create a shipping rate" do
    assert_difference("Merch::ShippingRate.count") do
      post admin_merch_shipping_rates_url, params: { merch_shipping_rate: { price: 18.50, weight: 5.15 } }
    end

    assert_response :see_other

    new_shipping_rate = Merch::ShippingRate.last
    assert_equal 18.50, new_shipping_rate.price
    assert_equal 5.15, new_shipping_rate.weight
  end

  test "edit should get edit" do
    get edit_admin_merch_shipping_rate_url(@shipping_rate), as: :turbo_stream
    assert_response :success
  end

  test "update should update shipping rate" do
    patch admin_merch_shipping_rate_url(@shipping_rate), params: { merch_shipping_rate: { price: 69, weight: 4.20 } }
    assert_response :see_other

    assert_equal 69, @shipping_rate.reload.price
    assert_equal 4.20, @shipping_rate.weight
  end

  test "destroy should destroy merch_shipping_rate" do
    assert_difference("Merch::ShippingRate.count", -1) do
      delete admin_merch_shipping_rate_url(@shipping_rate)
    end

    assert_response :see_other
  end
end
