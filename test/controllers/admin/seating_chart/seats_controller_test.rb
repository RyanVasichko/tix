require "application_integration_test_case"

class Admin::SeatingChart::SeatsControllerTest < ApplicationIntegrationTestCase
  test "should get new" do
    FactoryBot.create(:venue)

    get new_admin_seating_chart_url
    assert_response :success
  end
end
