require "test_helper"

class User::CustomerTest < ActiveSupport::TestCase
  test "destroying a Customer creates a GuestOrderer for their orders" do
    customer = FactoryBot.create(:customer,
                                 orders_count: 3,
                                 shopping_cart_merch_count: 2,
                                 reserved_seats_count: 2,
                                 general_admission_tickets_count: 2)
    orders = customer.orders
    reserved_seats = customer.shopping_cart.seats

    expected_differences = {
      "User::Customer.count" => -1,
      "Order::GuestOrderer.count" => 1,
      "User::ShoppingCart::Merch.count" => -2,
      "User::ShoppingCart::Ticket.count" => -2,
      "Show::Seat.count" => 0
    }
    assert_difference expected_differences do
      customer.destroy!
    end

    orders.each do |order|
      assert_equal order.reload.orderer.class, Order::GuestOrderer
      assert_equal order.orderer.first_name, customer.first_name
      assert_equal order.orderer.last_name, customer.last_name
      assert_equal order.orderer.email, customer.email
      assert_not_equal order.orderer.shopper_uuid, customer.shopper_uuid
    end

    reserved_seats.each { |seat| assert_not seat.reserved? }
  end
end
