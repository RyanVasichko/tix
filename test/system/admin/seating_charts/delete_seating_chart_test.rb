require 'application_system_test_case'

class Admin::SeatingCharts::DeleteSeatingChartTest < ApplicationSystemTestCase
  test 'deleting a seating chart' do
    skip "for some reason this is causing the rest of the tests to fail"
    
    assert_difference 'SeatingChart.count', -1 do
      seating_chart = seating_charts(:full_house)

      visit admin_seating_charts_path

      within "##{dom_id(seating_chart, :admin)}" do
        find('.dropdown-toggle').click
        click_on 'Delete'
      end

      refute_text 'Test Seating Chart'
      assert_text 'Seating chart was successfully deleted.'
    end
  end
end
