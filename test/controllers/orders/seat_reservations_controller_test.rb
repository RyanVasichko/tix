require "application_integration_test_case"

class Orders::SeatReservationsControllerTest < ApplicationIntegrationTestCase
  test "should destroy seat reservation" do
    @user = FactoryBot.create(:customer)
    @show = FactoryBot.create(:reserved_seating_show)

    @seat = @show.seats.first
    @seat.reserve_for(@user)

    log_in_as(@user, "password")

    assert_difference -> { @user.reserved_seats.count }, -1 do
      delete orders_seat_reservations_url(@seat), as: :turbo_stream
    end
  end
end
