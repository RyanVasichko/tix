require "test_helper"

class Show::SeatTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  setup do
    @section = FactoryBot.create(:reserved_seating_show_section)
    @user = FactoryBot.create(:customer)
    @seat = @section.seats.first
  end

  test "reserves a seat" do
    assert_nil @seat.reserved_by
    assert_nil @seat.reserved_until

    @seat.reserve_for!(@user)

    assert_equal @user.shopping_cart, @seat.shopping_cart
    assert_in_delta Time.current + 15.minutes, @seat.reserved_until, 1.second
  end

  test "cancels a reservation" do
    @seat.reserve_for!(@user)

    assert_equal @user, @seat.reserved_by

    @seat.cancel_reservation_for!(@user)

    assert_nil @seat.shopping_cart
    assert_nil @seat.reserved_until
  end

  test "expiration job works correctly" do
    @seat.reserve_for!(@user)

    travel_to Time.current + 16.minutes do
      perform_enqueued_jobs

      @seat.reload

      assert_nil @seat.shopping_cart
      assert_nil @seat.reserved_until
    end
  end

  test "seats broadcast updates when reserved" do
    skip "Does broadcasting not work here?"

    assert_broadcasts([@section.show, "seating_chart"], 1) do
      perform_enqueued_jobs(except: ExpireSeatReservationJob) do
        @seat.reserve_for!(@user)
      end
    end
  end

  test "seats broadcast updates when a reservation is canceled" do
    skip "Does broadcasting not work here?"

    @seat.reserve_for!(@user)

    assert_broadcasts([@section.show, "seating_chart"], 1) do
      @seat.cancel_reservation_for!(@user)
      perform_enqueued_jobs
    end
  end

  test "should touch ShoppingCart when shopping_cart_id is set to nil" do
    @seat.reserve_for!(@user)
    shopping_cart = @seat.shopping_cart
    original_updated_at = shopping_cart.updated_at

    travel 1.minute do
      @seat.cancel_reservation_for!(@user)
      shopping_cart.reload

      assert_operator shopping_cart.updated_at, :>, original_updated_at + 59.seconds
    end
  end
end
