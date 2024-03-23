require "test_helper"

class Shows::ReservedSeating::SeatHoldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = FactoryBot.create(:admin)

    sign_in @admin
    @show = FactoryBot.create(:reserved_seating_show)
    @show.seats.limit(3).each do |seat|
      seat.ticket.select_for!(@admin)
      seat.reload.hold_for!(@admin)
    end
  end

  test "should create seat holds" do
    @show.seats.reload.limit(3).not_held.not_sold.each do |seat|
      seat.ticket.select_for!(@admin)
    end
    assert_difference -> { @show.seats.reload.held.count }, 3 do
      post shows_reserved_seating_seat_holds_url(@show)
    end

    assert_response :redirect
  end

  test "should get index" do
    get shows_reserved_seating_seat_holds_url(@show)

    assert_response :success
  end

  test "should destroy a seat hold" do
    seat = @show.seats.reload.held.first

    assert_difference -> { @show.seats.reload.held.count }, -1 do
      delete shows_reserved_seating_seat_hold_url(@show, seat), as: :turbo_stream
    end

    assert_response :success
  end
end
