require "application_integration_test_case"

class ShoppingCart::SeatReservationsControllerTest < ApplicationIntegrationTestCase
  test "should destroy a seat reservation" do
    log_in_as(users(:larry_sellers), "password")

    seat = show_seats(:radiohead_premium_20_22)
    seat.reserve_for(users(:larry_sellers))

    delete shopping_cart_seat_reservation_url(seat)
    assert_response :see_other

    assert seat.reload.reserved_by.nil?
  end
end
