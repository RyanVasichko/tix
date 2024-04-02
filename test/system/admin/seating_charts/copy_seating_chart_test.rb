require "application_system_test_case"

class Admin::SeatingCharts::CopySeatingChartTest < ApplicationSystemTestCase
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "copying a seating chart" do
    seating_chart = FactoryBot.create(:seating_chart)

    expected_differences = {
      -> { SeatingChart.count } => 1,
      -> { SeatingChart::Section.count } => seating_chart.sections.count,
      -> { SeatingChart::Seat.count } => seating_chart.seats.count
    }
    assert_difference expected_differences do
          visit admin_seating_charts_path

          within "tr", text: seating_chart.name do
            click_on "Copy"
          end

          click_on "Save"

          assert_text "Seating chart was successfully created."
    end
  end
end
