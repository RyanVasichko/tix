require "test_helper"

class ShoppingCartsControllerTest  < ActionDispatch::IntegrationTest
  test "should show the shopping cart" do
    user = FactoryBot.create :customer,
                             shopping_cart_merch_count: 2,
                             reserved_seats_count: 2,
                             general_admission_tickets_count: 2
    sign_in user

    get shopping_carts_url
    assert_response :success
  end
end
