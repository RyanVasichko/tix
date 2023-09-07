require 'test_helper'

class Admin::SeatingChartsControllerTest < ActionDispatch::IntegrationTest
  test 'should create seating chart with two sections and two seats in each' do
    params = {
      seating_chart: {
        name: 'Test Seating Chart',
        venue_layout: fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'seating_chart.bmp'), 'image/bmp'),
        sections_attributes: {
          '0' => {
            name: 'Section 1',
            seats_attributes: {
              '0' => { seat_number: '1', table_number: '1', x: 10, y: 10 },
              '1' => { seat_number: '2', table_number: '1', x: 20, y: 20 }
            }
          },
          '1' => {
            name: 'Section 2',
            seats_attributes: {
              '0' => { seat_number: '1', table_number: '2', x: 30, y: 30 },
              '1' => { seat_number: '2', table_number: '2', x: 40, y: 40 }
            }
          }
        }
      }
    }

    post('/admin/seating_charts', params:)

    assert_response :redirect

    seating_chart = SeatingChart.last
    assert_equal 2, seating_chart.sections.count
    seating_chart.sections.each do |section|
      assert_equal 2, section.seats.count
    end

    assert_redirected_to admin_seating_charts_url
    assert_equal 'Seating chart was successfully created.', flash[:notice]
  end
end
