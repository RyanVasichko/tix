require "application_system_test_case"

class ShowsTest < ApplicationSystemTestCase
  setup do
    @show = FactoryBot.create(:show)
    @show.venue_layout.analyze unless @show.venue_layout.analyzed?
  end

  test "visiting the index" do
    visit shows_url
    assert_selector "h1", text: "Upcoming Shows"
  end

  test "visiting a show" do
    visit show_url(@show)

    assert_selector "h1", text: @show.artist_name
  end

  test "reserving a seat" do
    customer = FactoryBot.create(:customer)
    log_in_as customer, "password"

    seat = @show.seats.where(shopping_cart: nil).first

    assert_difference "customer.reserved_seats.reload.count", 1 do
      visit show_url(@show)
      find("##{dom_id(seat)}").click

      assert_selector "##{dom_id(seat)}[fill=yellow]"
    end

    within("#shopping_cart_count") { assert_text "1" }
    assert_equal seat.reload.reserved_by, customer

    sleep 0.25
    find("#shopping_cart_toggle").click

    assert_selector "#shopping_cart"
    within("#shopping_cart") { assert_text "Table #{seat.table_number} Seat #{seat.seat_number}" }
  end

  test "cancelling a seat reservation" do
    customer = FactoryBot.create(:customer)
    log_in_as customer, "password"

    seat = @show.seats.where(shopping_cart: nil).first
    seat.reserve_for(customer)

    assert_difference "customer.reserved_seats.reload.count", -1 do
      visit show_url(@show)
      find("##{dom_id(seat)}").click

      assert_selector "##{dom_id(seat)}[fill=green]"
    end

    within("#shopping_cart_count") { assert_text "0" }
    assert_nil seat.reload.reserved_by

    sleep 0.25
    find("#shopping_cart_toggle").click

    within("#shopping_cart") { refute_text "Table #{seat.table_number} Seat #{seat.seat_number}" }
  end
end
