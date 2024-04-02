require "test_helper"

class Admin::SeatingCharts::SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "should get new with turbo stream format" do
    get new_admin_seating_charts_section_url, headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success

    assert_match "turbo-stream", response.body
  end
end
