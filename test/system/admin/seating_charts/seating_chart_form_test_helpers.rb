module Admin::SeatingCharts::SeatingChartFormTestHelpers
  def add_seat(seat_number:, table_number:, section_name:)
    click_on "Add Seat"
    assert_selector("#edit-seat-modal", visible: true)

    within("#edit-seat-modal") do
      fill_in "Seat Number:", with: seat_number
      fill_in "Table Number:", with: table_number
      select section_name, from: "Section:"
      click_on "Save changes"
    end
    assert_no_selector("#edit-seat-modal", visible: true)
    seat_selector = "circle[data-admin--seating-chart-form--seat-seat-number-value='#{seat_number}'][data-admin--seating-chart-form--seat-table-number-value='#{table_number}']"
    find(seat_selector)
  end

  def add_section(name, ticket_type_name, use_existing_input: false)
    unless use_existing_input
      initial_input_count = all(".section-name-input").size
      click_on "Add Section" unless use_existing_input
      assert_selector ".section-name-input", count: initial_input_count + 1
    end

    within("#seating_chart_sections") do
      all(".section-name-input").last.set(name)
      all(".section-ticket-type-select").last.select(ticket_type_name)
    end
  end

  def close_slide_over
    click_on "btn-slide-over-close"
  end

  def open_slide_over
    click_on "btn-slide-over-toggle"
  end
end
