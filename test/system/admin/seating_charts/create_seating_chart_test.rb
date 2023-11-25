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
    venues = FactoryBot.create_list(:venue, 3, ticket_types_count: 4)
    selected_venue = venues.sample
    sections_params = [
      { name: 'Test Section 1', ticket_type_name: selected_venue.ticket_types.first.name },
      { name: 'Test Section 2', ticket_type_name: selected_venue.ticket_types.second.name },
      { name: 'Test Section 3', ticket_type_name: selected_venue.ticket_types.third.name }
    ]

    visit new_admin_seating_chart_path

    find('#seating_chart_name').set('Test Seating Chart')
    select selected_venue.name, from: 'Venue'

    create_test_sections(sections_params)
    click_on "btn-slide-over-close"
    create_test_seats
    click_on "btn-slide-over-toggle"

    find("input[type='file']", visible: false).set(Rails.root.join('test/fixtures/files/seating_chart.bmp'))

    click_on 'Save'

    assert_text 'Seating chart was successfully created.'

    seating_chart = SeatingChart.includes(sections: [:seats]).last

    assert_equal 'Test Seating Chart', seating_chart.name
    assert_equal 3, seating_chart.sections.count
    assert seating_chart.venue_layout.attached?
    assert_equal selected_venue, seating_chart.venue

    sections_params.each do |section_params|
      assert seating_chart.sections.joins(:ticket_type).where(
        name: section_params[:name],
        ticket_types: { name: section_params[:ticket_type_name] }
      ).exists?
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
      )

      assert seat_within_tolerance.exists?
    end
  end

  def create_test_sections(sections_params)
    sections_params.each_with_index do |section_params, i|
      add_section(section_params[:name], section_params[:ticket_type_name], use_existing_input: i == 0)
    end
  end

  def create_test_seats
    3.times do |i|
      new_seat = add_seat(seat_number: i + 1, table_number: i + 10, section_name: "Test Section #{i + 1}")
      drag_to(new_seat, DRAG_TO_COORDINATES[i][:x], DRAG_TO_COORDINATES[i][:y])
    end
  end
end
