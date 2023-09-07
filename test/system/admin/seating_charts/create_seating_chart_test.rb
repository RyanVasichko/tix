require 'application_system_test_case'
require 'system/admin/seating_charts/seating_chart_form_test_helpers'

class Admin::SeatingCharts::CreateSeatingChartTest < ApplicationSystemTestCase
  include Admin::SeatingCharts::SeatingChartFormTestHelpers

  DRAG_TO_COORDINATES = [
    { x: 100, y: 100 },
    { x: 100, y: 200 },
    { x: 100, y: 300 }
  ]
  TOLERANCE = 2

  test 'creating a seating chart' do
    visit new_admin_seating_chart_path

    fill_in 'Name', with: 'Test Seating Chart'

    create_test_sections
    create_test_seats

    attach_file('Venue layout', Rails.root.join('test/fixtures/files/seating_chart.bmp'))

    click_on 'Save'

    assert_text 'Seating chart was successfully created.'

    seating_chart = SeatingChart.includes(sections: [:seats]).last

    assert_equal 'Test Seating Chart', seating_chart.name
    assert_equal 3, seating_chart.sections.count
    assert seating_chart.venue_layout.attached?

    3.times do |i|
      assert seating_chart.sections.where(name: "Test Section #{i + 1}").exists?
    end

    assert_equal 3, seating_chart.seats.count

    3.times do |i|
      section = seating_chart.sections.find_by(name: "Test Section #{i + 1}")
      assert section.seats.where(seat_number: i + 1, table_number: i + 10).exists?

      target_x = DRAG_TO_COORDINATES[i][:x]
      target_y = DRAG_TO_COORDINATES[i][:y]
    
      seat_within_tolerance = seating_chart.seats.where(
        x: (target_x - TOLERANCE)..(target_x + TOLERANCE),
        y: (target_y - TOLERANCE)..(target_y + TOLERANCE)
      ).exists?
    end
  end

  def create_test_sections
    3.times do |i|
      add_section("Test Section #{i + 1}", use_existing_input: i == 0)
    end
  end

  def create_test_seats
    3.times do |i|
      new_seat = add_seat(seat_number: i + 1, table_number: i + 10, section_name: "Test Section #{i + 1}")
      drag_to(new_seat, DRAG_TO_COORDINATES[i][:x], DRAG_TO_COORDINATES[i][:y])
    end
  end
end
