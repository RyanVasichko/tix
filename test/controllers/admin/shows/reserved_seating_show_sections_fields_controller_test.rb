require "application_integration_test_case"

class Admin::Shows::ReservedSeatingShowSectionsFieldsControllerTest < ApplicationIntegrationTestCase
  test "should get index" do
    seating_chart = FactoryBot.create(:seating_chart)

    get admin_shows_seating_chart_reserved_seating_show_sections_fields_url(seating_chart_id: seating_chart.id), as: "turbo-stream"
    assert_response :success
  end
end
