require "test_helper"

class Orders::SeatReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should destroy seat reservation" do
    @user = FactoryBot.create(:customer)
    @show = FactoryBot.create(:reserved_seating_show)

    @seat = @show.seats.first
    @seat.reserve_for(@user)

    sign_in @user

    assert_difference -> { @user.reserved_seats.count }, -1 do
      delete orders_seat_reservations_url(@seat), as: :turbo_stream
    end
  end
end
