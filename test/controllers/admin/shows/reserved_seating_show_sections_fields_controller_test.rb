require "test_helper"

class Admin::Shows::ReservedSeatingShowSectionsFieldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "should get index" do
    seating_chart = FactoryBot.create(:seating_chart)

    get admin_shows_seating_chart_reserved_seating_show_sections_fields_url(seating_chart_id: seating_chart.id), as: :turbo_stream
    assert_response :success
  end
end
