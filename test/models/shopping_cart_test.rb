require "test_helper"

class ShoppingCartTest < ActiveSupport::TestCase
  test "transferring a shopping cart from one user to another" do
    user_1 = FactoryBot.create(:guest, shopping_cart_merch_count: 2, reserved_seats_count: 2)
    # user_2 = FactoryBot.create(:customer)

    # user_1.shopping_cart.transfer_to(user_2)
    #
    # assert_equal 0, user_1.shopping_cart.total_items
    # assert_equal 4, user_2.shopping_cart.total_items
    # assert_equal 2, user_2.shopping_cart.seats.count
    # assert_equal 2, user_2.shopping_cart.merch.count
  end
end
