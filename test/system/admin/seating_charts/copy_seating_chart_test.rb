require 'application_system_test_case'

class Admin::SeatingCharts::CopySeatingChartTest < ApplicationSystemTestCase
  test 'copying a seat' do
    seating_chart = FactoryBot.create(:seating_chart)
    
    assert_difference 'SeatingChart.count', 1 do
      assert_difference 'SeatingChart::Section.count', seating_chart.sections.count do
        assert_difference 'SeatingChart::Seat.count', seating_chart.seats.count do
          visit admin_seating_charts_path

          find("##{dom_id(seating_chart, :admin)}_dropdown").click
          click_on 'Copy'
          
          click_on 'Save'

          assert_text 'Seating chart was successfully created.'
        end
      end
    end
  end
end
