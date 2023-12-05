require "application_integration_test_case"

class ShowsControllerTest < ApplicationIntegrationTestCase
  setup do
    FactoryBot.create(:reserved_seating_show)
    FactoryBot.create(:general_admission_show)
  end

  test "should get index" do
    get shows_url
    assert_response :success
  end
end
