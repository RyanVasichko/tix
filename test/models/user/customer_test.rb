require "test_helper"

class Users::CustomerTest < ActiveSupport::TestCase
  test "destroying a Customer creates a GuestOrderer for their orders" do
    customer = FactoryBot.create(:customer, orders_count: 1)
    order = customer.orders.first

    expected_differences = {
      "Users::Customer.count" => -1,
      "Order::GuestOrderer.count" => 1,
      "Order::Purchase.count" => 0,
      "Show::Seat.count" => 0
    }
    assert_difference expected_differences do
      customer.destroy!
    end

    assert_equal order.reload.orderer.class, Order::GuestOrderer
    assert_equal order.orderer.first_name, customer.first_name
    assert_equal order.orderer.last_name, customer.last_name
    assert_equal order.orderer.email, customer.email
    assert_not_equal order.orderer.shopper_uuid, customer.shopper_uuid
  end

  test "destroying a Customer empties their shopping cart" do
    customer = FactoryBot.create(:customer,
                                 shopping_cart_merch_count: 2,
                                 reserved_seats_count: 2,
                                 general_admission_tickets_count: 2)

    expected_differences = {
      "Users::Customer.count" => -1,
      "ShoppingCart::Selection.count" => -6,
      "Show::Seat.available.count" => 2,
      "Show::Seat.count" => 0,
      "Show::Section.count" => 0,
      "Merch.count" => 0
    }
    assert_difference expected_differences do
      customer.destroy!
    end
  end
end
