require 'application_system_test_case'

class Admin::SeatingCharts::CopySeatingChartTest < ApplicationSystemTestCase
  test 'copying a seat' do
    full_house = seating_charts(:full_house)
    
    assert_difference 'SeatingChart.count', 1 do
      assert_difference 'SeatingChart::Section.count', full_house.sections.count do
        assert_difference 'SeatingChart::Seat.count', full_house.seats.count do
          visit admin_seating_charts_path

          find("##{dom_id(full_house, :admin)}_dropdown").click
          click_on 'Copy'

          click_on 'Save'

          assert_text 'Seating chart was successfully created.'
        end
      end
    end
  end
end
