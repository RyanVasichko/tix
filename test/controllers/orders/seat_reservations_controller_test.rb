require "application_integration_test_case"

class Orders::SeatReservationsControllerTest < ApplicationIntegrationTestCase
  test 'should destroy seat reservation' do
    @larry_sellers = users(:larry_sellers)
    @show = shows(:radiohead)

    @seat = @show.seats.first
    @seat.reserve_for(@larry_sellers)

    log_in_as(@larry_sellers, "password")

    assert_difference -> { @larry_sellers.reserved_seats.count }, -1 do
      delete orders_seat_reservations_url(@seat), as: :turbo_stream
    end
  end
end