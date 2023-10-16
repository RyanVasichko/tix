require "application_integration_test_case"

class Shows::SeatReservationsControllerTest < ApplicationIntegrationTestCase
  setup do
    @show = shows(:radiohead)
    @user = users(:larry_sellers)
    @show.build_seats
    @show.save!

    @seat = @show.seats.first

    log_in_as(@user, "password")
  end

  test "should reserve a seat for a show responding using turbo streams" do
    post show_seat_reservation_url(@show, seat_id: @seat.id), as: :turbo_stream

    assert_equal @user, @seat.reload.reserved_by
  end

  test "should reserve a seat for a show even if turbo streams aren't working" do
    post show_seat_reservation_url(@show, seat_id: @seat.id)

    assert_equal @user, @seat.reload.reserved_by
  end

  test "should cancel a seat reservation using turbo streams" do
    @seat.reserve_for(@user)

    delete show_seat_reservation_url(@show, seat_id: @seat.id), as: :turbo_stream

    assert_nil @seat.reload.reserved_by
    assert_nil @seat.reserved_until
  end

  test "should cancel a seat reservation even if turbo streams aren't working" do
    @seat.reserve_for(@user)

    delete show_seat_reservation_url(@show, seat_id: @seat.id)

    assert_nil @seat.reload.reserved_by
    assert_nil @seat.reserved_until
  end
end
