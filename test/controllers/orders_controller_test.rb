require "application_integration_test_case"

class OrdersControllerTest < ApplicationIntegrationTestCase
  setup do
    @user = FactoryBot.create(:customer, :with_password)
    log_in_as @user, "password"
    @order = FactoryBot.create(:customer_order, orderer: @user)
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "should get new" do
    FactoryBot.create(:shopping_cart_merch, shopping_cart: @user.shopping_cart)
    get new_order_url
    assert_response :success
  end

  test "should create order" do
    skip

    assert_difference("Order.count") do
      post orders_url, params: { order: {} }
    end

    assert_redirected_to order_url(Order.last)
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end
end
