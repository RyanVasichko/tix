require "application_system_test_case"

class ReservedSeatingShowsTest < ApplicationSystemTestCase
  setup do
    @show = FactoryBot.create(:reserved_seating_show)
    @show.venue_layout.analyze unless @show.venue_layout.analyzed?
  end

  test "visiting a show" do
    visit reserved_seating_show_url(@show)

    assert_selector "h1", text: @show.artist_name
  end

  test "reserving a seat" do
    customer = FactoryBot.create(:customer)
    log_in_as customer

    seat = @show.seats.where(shopping_cart: nil).first

    assert_difference "customer.reserved_seats.reload.count", 1 do
      visit reserved_seating_show_url(@show)
      find("##{dom_id(seat)}").click

      assert_selector "##{dom_id(seat)}[fill=yellow]"
      assert_selector "#shopping_cart_count", text: "1"
    end

    perform_enqueued_jobs

    within("#shopping_cart_count") { assert_text "1" }
    assert_equal seat.reload.reserved_by, customer

    sleep 0.25
    find("#shopping_cart_toggle").click

    assert_selector "#shopping_cart"
    within("#shopping_cart") { assert_text "Table #{seat.table_number} Seat #{seat.seat_number}" }
  end

  test "cancelling a seat reservation" do
    customer = FactoryBot.create(:customer)
    log_in_as customer

    seat = @show.seats.where(shopping_cart: nil).first
    seat.reserve_for(customer)

    assert_difference "customer.reserved_seats.reload.count", -1 do
      visit reserved_seating_show_url(@show)
      find("##{dom_id(seat)}").click

      assert_selector "##{dom_id(seat)}[fill=green]"
      assert_selector "#shopping_cart_count", text: "0"
    end

    perform_enqueued_jobs
    within("#shopping_cart_count") { assert_text "0" }
    assert_nil seat.reload.reserved_by

    sleep 0.25
    find("#shopping_cart_toggle").click

    within("#shopping_cart") { refute_text "Table #{seat.table_number} Seat #{seat.seat_number}" }
  end

  test "holding seats" do
    admin = FactoryBot.create(:admin)
    log_in_as admin

    available_seats = @show.seats.merge(Show::Seat.not_sold).merge(Show::Seat.not_held).limit(2)
    seat_1 = available_seats.first
    seat_1.reserve_for(admin)

    seat_2 = available_seats.second
    seat_2.reserve_for(admin)

    visit root_path
    find("#shopping_cart_toggle").click
    click_on "Hold Seats"

    within("#shopping_cart_count") { assert_text "0" }

    assert seat_1.reload.held?
    assert seat_2.reload.held?

    visit reserved_seating_show_url(@show)
    assert_selector "##{dom_id(seat_1)}[fill=purple]"
    assert_selector "##{dom_id(seat_2)}[fill=purple]"

    click_on "Seat Holds"
    within "##{dom_id(seat_1)}_hold" do
      click_on "Release"
    end
    assert_no_css "##{dom_id(seat_1)}_hold"
    refute seat_1.reload.held?
    assert seat_2.reload.held?
  end
end