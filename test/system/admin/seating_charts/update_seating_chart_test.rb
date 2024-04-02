require "application_system_test_case"
require "system/admin/seating_charts/seating_chart_form_test_helpers"

class Admin::SeatingCharts::UpdateSeatingChartTest < ApplicationSystemTestCase
  include Admin::SeatingCharts::SeatingChartFormTestHelpers

  setup do
    sign_in FactoryBot.create(:admin)
    @venue = FactoryBot.create(:venue, ticket_types_count: 3)
    @seating_chart = FactoryBot.create(:seating_chart, sections_count: 2, section_seats_count: 2, venue: @venue)
    @section_1 = @seating_chart.sections.first
    @section_2 = @seating_chart.sections.second
    @seat_to_delete = @section_1.seats.first
    @seating_chart.venue_layout.attachment.analyze
    visit edit_admin_seating_chart_path(@seating_chart)
  end

  test "updating seating chart name" do
    # I have no clue why, but for some reason this fails if I don't do .set("") before setting the name
    find("#seating_chart_name").set("").set("Updated name")
    click_on "Save"
    assert_text "Seating chart was successfully updated."
    @seating_chart.reload
    assert_equal "Updated name", @seating_chart.name
  end

  test "adding a new seat to a section" do
    close_slide_over
    new_seat = add_seat(seat_number: 5, table_number: 6, section_name: @section_1.name)
    sleep 0.1
    drag_to(new_seat, 678, 732)
    open_slide_over

    assert_difference "@section_1.seats.reload.count", 1 do
      click_on "Save"
      assert_text "Seating chart was successfully updated."
    end

    @section_1.reload

    assert_in_delta 678, @section_1.seats.last.x, 2
    assert_in_delta 732, @section_1.seats.last.y, 2
    assert_equal "5", @section_1.seats.last.seat_number
    assert_equal "6", @section_1.seats.last.table_number
  end

  test "adding a new section and a seat" do
    ticket_type = @venue.ticket_types.third

    add_section("New Section", ticket_type.name)
    close_slide_over

    add_seat(seat_number: 13, table_number: 14, section_name: "New Section")
    open_slide_over

    assert_difference "@seating_chart.sections.reload.count", 1 do
      click_on "Save"
      assert_text "Seating chart was successfully updated."
    end

    new_section = SeatingChart::Section.find_by(name: "New Section", ticket_type: ticket_type)
    assert_not_nil new_section
    assert_equal 1, new_section.seats.count

    new_seat = new_section.seats.last
    assert_equal "13", new_seat.seat_number
    assert_equal "14", new_seat.table_number
  end

  test "removing a section" do
    assert_difference -> { @seating_chart.sections.count } => -1, -> { @seating_chart.seats.count } => -2 do
      within "#seating_chart_section_#{@section_2.id}_fields" do
        click_on "Remove section"
      end
      click_on "Save"
      assert_text "Seating chart was successfully updated."
    end
    assert_not SeatingChart::Section.exists?(@section_2.id)
  end

  test "deleting a seat" do
    close_slide_over
    find("circle[data-admin--seating-chart-form--seat-id-value='#{@seat_to_delete.id}']").click
    assert_selector("#edit-seat-modal", visible: true)
    within("#edit-seat-modal") do
      click_on "Delete"
    end
    assert_no_selector("#edit-seat-modal", visible: true)

    open_slide_over
    click_on "Save"
    assert_text "Seating chart was successfully updated."

    assert_not SeatingChart::Seat.exists?(@seat_to_delete.id)
  end

  test "updating a seat" do
    close_slide_over

    seat = @section_1.seats.first
    find("circle[data-admin--seating-chart-form--seat-id-value='#{seat.id}']").click
    assert_selector("#edit-seat-modal", visible: true)

    within("#edit-seat-modal") do
      fill_in "Seat Number", with: "123"
      fill_in "Table Number", with: "456"
      click_on "Save"
    end
    assert_no_selector("#edit-seat-modal", visible: true)

    open_slide_over
    click_on "Save"

    assert_text "Seating chart was successfully updated."

    assert "123", seat.reload.seat_number
    assert "456", seat.table_number
  end

  test "updating a seat and moving it to a new section" do
    close_slide_over

    seat = @section_1.seats.first
    find("circle[data-admin--seating-chart-form--seat-id-value='#{seat.id}']").click
    assert_selector("#edit-seat-modal", visible: true)

    within("#edit-seat-modal") do
      fill_in "Seat Number", with: "123"
      fill_in "Table Number", with: "456"
      select @section_2.name, from: "Section"
      click_on "Save"
    end
    assert_no_selector("#edit-seat-modal", visible: true)

    open_slide_over
    assert_difference -> { @section_1.seats.count } => -1, -> { @section_2.seats.count } => 1 do
      click_on "Save"
      assert_text "Seating chart was successfully updated."
    end

    assert_not SeatingChart::Seat.exists?(seat.id)
    assert SeatingChart::Seat.exists?(section: @section_2, seat_number: "123", table_number: "456")
  end
end
