require "test_helper"

class Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in FactoryBot.create(:admin)

    FactoryBot.create_list(:customer_order, 3)
    FactoryBot.create_list(:guest_order, 3)

    get admin_orders_url

    assert_response :success
  end
end
