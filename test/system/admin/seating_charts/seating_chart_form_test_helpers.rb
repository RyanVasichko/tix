module Admin::SeatingCharts::SeatingChartFormTestHelpers
  def add_seat(seat_number:, table_number:, section_name:)
    click_on 'Add Seat'
    assert_selector('#edit-seat-modal', visible: true)

    within('#edit-seat-modal') do
      fill_in 'Seat Number:', with: seat_number
      fill_in 'Table Number:', with: table_number
      select section_name, from: 'Section:'

      sleep 0.5 # Needed for the test to pass

      click_on 'Save changes'
      # Wait for the modal to go away
      assert_no_selector('#edit-seat-modal', visible: true)
    end

    all("circle").last
  end

  def add_section(name, use_existing_input: false)
    click_on 'btn-add-section' unless use_existing_input
    sleep 0.25 # Wait for the new input to get rendered

    within('#seating_chart_sections') do
      all('.section-name-input').last.set(name)
    end
  end
end