require "application_integration_test_case"

class ShoppingCart::SeatReservationsControllerTest < ApplicationIntegrationTestCase
  test "should destroy a seat reservation" do
    user = FactoryBot.create(:customer, password: "password", password_confirmation: "password")
    log_in_as(user, "password")

    seat = FactoryBot.build(:show_seat)
    seat.reserve_for(user)

    delete shopping_cart_seat_reservation_url(seat)
    assert_response :no_content

    assert seat.reload.shopping_cart.nil?
  end
end
