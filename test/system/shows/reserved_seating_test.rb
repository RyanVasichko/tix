require "application_system_test_case"

class Shows::ReservedSeatingTest < ApplicationSystemTestCase
  setup do
    @show = FactoryBot.create(:reserved_seating_show)
    @show.venue_layout.analyze unless @show.venue_layout.analyzed?
  end

  test "visiting a show" do
    visit shows_reserved_seating_url(@show)

    assert_selector "h1", text: @show.artist_name
  end

  test "reserving a seat" do
    customer = FactoryBot.create(:customer)
    sign_in customer

    seat = @show.seats.available.first

    assert_difference "customer.shopping_cart_selections.tickets.count", 1 do
      visit shows_reserved_seating_url(@show)
      find("##{dom_id(seat)}").click

      assert_selector "##{dom_id(seat)}[fill=yellow]"
      assert_selector "#shopping_cart_count", text: "1"
    end

    perform_enqueued_jobs

    within("#shopping_cart_count") { assert_text "1" }
    assert_equal seat.reload.selected_by, customer

    sleep 0.25
    find("#shopping_cart_toggle").click

    assert_selector "#shopping_cart"
    within("#shopping_cart") { assert_text "Table #{seat.table_number} Seat #{seat.seat_number}" }
  end

  test "cancelling a seat reservation" do
    customer = FactoryBot.create(:customer)
    sign_in customer

    seat = @show.seats.available.first
    seat.ticket.select_for!(customer)

    assert_difference "customer.shopping_cart_selections.tickets.count", -1 do
      visit shows_reserved_seating_url(@show)
      find("##{dom_id(seat)}").click

      assert_selector "##{dom_id(seat)}[fill=green]"
      assert_selector "#shopping_cart_count", text: "0"
    end

    perform_enqueued_jobs
    within("#shopping_cart_count") { assert_text "0" }
    assert_nil seat.reload.selected_by

    sleep 0.25
    find("#shopping_cart_toggle").click

    within("#shopping_cart") { refute_text "Table #{seat.table_number} Seat #{seat.seat_number}" }
  end

  test "holding seats" do
    admin = FactoryBot.create(:admin)
    sign_in admin

    available_seats = @show.seats.merge(Show::Seat.not_sold).merge(Show::Seat.not_held).limit(2)
    seat = available_seats.first
    seat.ticket.select_for!(admin)

    visit root_path
    find("#shopping_cart_toggle").click
    click_on "Hold Seats"

    within("#shopping_cart_count") { assert_text "0" }

    assert seat.reload.held?

    visit shows_reserved_seating_url(@show)
    assert_selector "##{dom_id(seat)}[fill=purple]"

    click_on "Seat Holds"
    within "##{dom_id(seat)}_hold" do
      click_on "Release"
    end
    assert_no_css "##{dom_id(seat)}_hold"
    assert_not seat.reload.held?
  end
end
