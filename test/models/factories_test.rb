require "test_helper"

class FactoriesTest < ActiveSupport::TestCase
  test "FactoryBot lints" do
    assert_nothing_raised do
      FactoryBot.lint
    end
  end

  test "factories make the correct number of objects" do
    expected_seating_chart_count_differences = {
      "SeatingChart.count" => 3,
      "SeatingChart::Section.count" => 12,
      "SeatingChart::Seat.count" => 240
    }

    assert_difference(expected_seating_chart_count_differences) do
      FactoryBot.create_list(:seating_chart, 3, sections_count: 4, section_seats_count: 20)
    end

    artists = FactoryBot.create_list(:artist, 3)

    expected_show_count_differences = {
      "SeatingChart.count" => 0,
      "SeatingChart::Section.count" => 0,
      "SeatingChart::Seat.count" => 0,
      "Show.count" => 5,
      "Show::Section.count" => 10,
      "Show::Seat.count" => 50,
      "Artist.count" => 2
    }

    assert_difference(expected_show_count_differences) do
      2.times do
        FactoryBot.create(:reserved_seating_show)
      end

      3.times do
        FactoryBot.create(:reserved_seating_show, artist: artists.sample)
      end
    end

    # expected_differences = {
    #   "SeatingChart.count" => 1,
    #   "SeatingChart::Section.count" => 2,
    #   "SeatingChart::Seat.count" => 10,
    #   "Show.count" => 1,
    #   "Show::Section.count" => 2,
    #   "Show::Seat.count" => 10,
    #   "Artist.count" => 1
    # }
    #
    # assert_difference(expected_differences) do
    #   FactoryBot.create(:order, tickets_count: 2)
    # end
  end
end
