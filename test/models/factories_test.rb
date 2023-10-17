require "test_helper"

class FactoriesTest < ActiveSupport::TestCase
  test "factories lint" do
    FactoryBot.lint
  end

  test "factories make the correct number of objects" do
    expected_seating_chart_count_differences = {
      "SeatingChart.count" => 3,
      "SeatingChart::Section.count" => 12,
      "SeatingChart::Seat.count" => 240
    }

    seating_charts = nil

    assert_difference(expected_seating_chart_count_differences) do
      seating_charts = FactoryBot.create_list(:seating_chart, 3, sections_count: 4, section_seats_count: 20)
    end

    expected_show_count_differences = {
      "SeatingChart.count" => 0,
      "SeatingChart::Section.count" => 0,
      "SeatingChart::Seat.count" => 0,
      "Show.count" => 5,
      "Show::Section.count" => 20,
      "Show::Seat.count" => 400
    }

    assert_difference(expected_show_count_differences) do
      5.times do
        FactoryBot.create(:show, :skip_seating_chart, seating_chart: seating_charts.sample)
      end
    end
  end
end