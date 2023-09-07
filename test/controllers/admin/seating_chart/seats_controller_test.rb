require "test_helper"

class Admin::SeatingChart::SeatsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_admin_seating_chart_url
    assert_response :success
  end
end
