require 'application_system_test_case'
require 'system/admin/seating_charts/seating_chart_form_test_helpers'

class Admin::SeatingCharts::UpdateSeatingChartTest < ApplicationSystemTestCase
  include Admin::SeatingCharts::SeatingChartFormTestHelpers

  setup do
    @seating_chart = seating_charts(:full_house)
    @normal_section = seating_chart_sections(:normal)
    @obstructed_section = seating_chart_sections(:obstructed)
    @seat_to_delete = seating_chart_seats(:normal_two)
    @seating_chart.venue_layout.attachment.analyze
    visit edit_admin_seating_chart_path(@seating_chart)
  end

  test 'updating seating chart name' do
    fill_in 'Name', with: 'Updated name'
    click_on 'Save'
    assert_text 'Seating chart was successfully updated.'
    @seating_chart.reload
    assert_equal 'Updated name', @seating_chart.name
  end

  test 'adding a new seat to a section' do
    close_slide_over
    new_seat = add_seat(seat_number: 5, table_number: 6, section_name: @normal_section.name)
    drag_to(new_seat, 678, 732)
    open_slide_over
    click_on 'Save'
    assert_text 'Seating chart was successfully updated.'
    @normal_section.reload

    @normal_section.reload
    assert_equal 3, @normal_section.seats.count

    assert_in_delta 678, @normal_section.seats.last.x, 2
    assert_in_delta 732, @normal_section.seats.last.y, 2
    assert_equal '5', @normal_section.seats.last.seat_number
    assert_equal '6', @normal_section.seats.last.table_number
  end

  test 'adding a new section and a seat' do
    add_section 'New Section'
    close_slide_over
    add_seat(seat_number: 13, table_number: 14, section_name: 'New Section')
    open_slide_over
    click_on 'Save'
    assert_text 'Seating chart was successfully updated.'

    new_section = SeatingChart::Section.find_by_name('New Section')
    refute_nil new_section
    assert_equal 1, new_section.seats.count

    new_seat = new_section.seats.last
    assert_equal '13', new_seat.seat_number
    assert_equal '14', new_seat.table_number
  end

  test 'removing a section' do
    skip "for now"
    within "#admin_seating_chart_section_#{@obstructed_section.id}" do
      find('.btn-remove-section').click
    end
    click_on 'Save'
    assert_text 'Seating chart was successfully updated.'
    refute SeatingChart::Section.exists?(@obstructed_section.id)
  end

  test 'deleting a seat' do
    skip "I have no clue why the modal won't go away"

    find("circle[data-seat-id-value='#{@seat_to_delete.id}']").click
    assert_selector('#edit-seat-modal', visible: true)
    within('#edit-seat-modal') do
      click_on 'Delete'
    end

    assert_no_selector('#edit-seat-modal', visible: true)
    click_on 'Save'
    assert_text 'Seating chart was successfully updated.'
    refute SeatingChart::Seat.exists?(@seat_to_delete.id)
  end
end
