require "test_helper"

class Admin::Shows::SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "should get new" do
    get new_admin_seating_charts_section_url, as: :turbo_stream
    assert_response :success
  end
end
