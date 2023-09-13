require 'test_helper'

class Admin::SeatingCharts::SectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new with turbo stream format" do
    skip "for now"
    get new_admin_seating_charts_section_url, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
    assert_response :success

    assert_match "turbo-stream", response.body
  end
end
