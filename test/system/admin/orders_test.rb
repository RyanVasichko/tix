require "application_system_test_case"

class Admin::OrdersTest < ApplicationSystemTestCase
  test "visiting the index" do
    customer_orders = FactoryBot.create_list(:customer_order, 3)
    guest_orders = FactoryBot.create_list(:guest_order, 3)

    visit admin_orders_url

    customer_orders.each do |order|
      assert_text order.orderer.full_name
    end

    guest_orders.each do |order|
      assert_text order.orderer.full_name
    end
  end
end
