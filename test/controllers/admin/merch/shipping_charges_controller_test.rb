require "test_helper"

class Admin::Merch::ShippingChargesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shipping_charge = FactoryBot.create(:merch_shipping_charge)
  end

  test "should get index" do
    get admin_merch_shipping_charges_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_merch_shipping_charge_url, as: :turbo_stream
    assert_response :success
  end

  test "should create merch_shipping_charge" do
    assert_difference("Merch::ShippingCharge.count") do
      post admin_merch_shipping_charges_url, params: { merch_shipping_charge: { price: 18.50, weight: 5.15 } }
    end

    assert_response :see_other

    new_shipping_charge = Merch::ShippingCharge.last
    assert_equal 18.50, new_shipping_charge.price
    assert_equal 5.15, new_shipping_charge.weight
  end

  test "should get edit" do
    get edit_admin_merch_shipping_charge_url(@shipping_charge)
    assert_response :success
  end

  test "should update merch_shipping_charge" do
    patch admin_merch_shipping_charge_url(@shipping_charge), params: { merch_shipping_charge: { price: 69, weight: 4.20 } }
    assert_response :see_other

    assert_equal 69, @shipping_charge.reload.price
    assert_equal 4.20, @shipping_charge.weight
  end

  test "should destroy merch_shipping_charge" do
    assert_difference("Merch::ShippingCharge.count", -1) do
      delete admin_merch_shipping_charge_url(@shipping_charge)
    end

    assert_response :see_other
  end
end
