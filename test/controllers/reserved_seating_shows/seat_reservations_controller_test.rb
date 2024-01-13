require "application_integration_test_case"

class ReservedSeatingShows::SeatReservationsControllerTest < ApplicationIntegrationTestCase
  setup do
    @show = FactoryBot.create(:reserved_seating_show)
    @user = FactoryBot.create(:customer)
    @seat = @show.seats.first

    log_in_as(@user, "password")
  end

  test "should reserve a seat for a show responding using turbo streams" do
    post reserved_seating_show_seat_reservation_url(@show, seat_id: @seat.id), as: :turbo_stream

    assert_equal @user, @seat.reload.reserved_by
  end

  test "should reserve a seat for a show even if turbo streams aren't working" do
    post reserved_seating_show_seat_reservation_url(@show, seat_id: @seat.id)

    assert_equal @user, @seat.reload.reserved_by
  end

  test "should cancel a seat reservation using turbo streams" do
    @seat.reserve_for!(@user)

    delete reserved_seating_show_seat_reservation_url(@show, seat_id: @seat.id), as: :turbo_stream

    assert_nil @seat.reload.reserved_by
    assert_nil @seat.reserved_until
  end

  test "should cancel a seat reservation even if turbo streams aren't working" do
    @seat.reserve_for!(@user)

    delete reserved_seating_show_seat_reservation_url(@show, seat_id: @seat.id)

    assert_nil @seat.reload.shopping_cart
    assert_nil @seat.reserved_until
  end
end