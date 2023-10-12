require "application_system_test_case"

class ShowsTest < ApplicationSystemTestCase
  setup do
    @show = shows(:radiohead)
    @show.seating_chart.venue_layout.analyze unless @show.seating_chart.venue_layout.analyzed?
  end

  test "visiting the index" do
    visit shows_url
    assert_selector "h1", text: "Upcoming Shows"
  end

  test "visiting a show" do
    @show.seating_chart.venue_layout.analyze unless @show.seating_chart.venue_layout.analyzed?
    visit show_url(@show)

    assert_selector "h1", text: "Radiohead"
  end

  test "reserving a seat" do
    larry_sellers = users(:larry_sellers)
    log_in_as larry_sellers, "password"

    seat = @show.seats.where(reserved_by: nil).first

    assert_difference "larry_sellers.reserved_seats.reload.count", 1 do
      visit show_url(@show)
      find("##{dom_id(seat)}").click

      assert_selector "##{dom_id(seat)}[fill=yellow]"
    end

    within("#shopping_cart_count") { assert_text "6" }
    assert_equal seat.reload.reserved_by, larry_sellers

    sleep 0.25
    find("#shopping_cart_toggle").click

    assert_selector "#shopping_cart"
    within("#shopping_cart") { assert_text "Table #{seat.table_number} Seat #{seat.seat_number}" }
  end

  test "cancelling a seat reservation" do
    larry_sellers = users(:larry_sellers)
    log_in_as larry_sellers, "password"

    seat = @show.seats.where(reserved_by: nil).first
    seat.reserve_for(larry_sellers)

    assert_difference "larry_sellers.reserved_seats.reload.count", -1 do
      visit show_url(@show)
      find("##{dom_id(seat)}").click

      assert_selector "##{dom_id(seat)}[fill=green]"
    end

    within("#shopping_cart_count") { assert_text "5" }
    assert_nil seat.reload.reserved_by

    sleep 0.25
    find("#shopping_cart_toggle").click

    within("#shopping_cart") { refute_text "Table #{seat.table_number} Seat #{seat.seat_number}" }
  end
end
