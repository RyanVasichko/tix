require "test_helper"

class Show::SeatTest < ActiveSupport::TestCase
  setup do
    @section = show_sections(:radiohead_obstructed)
    @user = users(:larry_sellers)

    @seat = show_seats(:radiohead_obstructed_1_1)
  end

  test "reserves a seat" do
    assert_nil @seat.reserved_by
    assert_nil @seat.reserved_until

    @seat.reserve_for(@user)

    assert_equal @user, @seat.reserved_by
    assert_in_delta Time.current + 15.minutes, @seat.reserved_until, 1.second
  end

  test "cancels a reservation" do
    @seat.reserve_for(@user)

    assert_equal @user, @seat.reserved_by

    @seat.cancel_reservation!

    assert_nil @seat.reserved_by
    assert_nil @seat.reserved_until
  end

  test "expiration job works correctly" do
    @seat.reserve_for(@user)

    travel_to Time.current + 16.minutes do
      perform_enqueued_jobs

      @seat.reload

      assert_nil @seat.reserved_by
      assert_nil @seat.reserved_until
    end
  end
end
