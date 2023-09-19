require "application_integration_test_case"

class Admin::Shows::SectionsControllerTest < ApplicationIntegrationTestCase
  test "should get new" do
    get new_admin_seating_charts_section_url, as: :turbo_stream
    assert_response :success
  end
end
