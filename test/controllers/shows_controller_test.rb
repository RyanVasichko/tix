require "application_integration_test_case"

class ShowsControllerTest < ApplicationIntegrationTestCase
  setup do
    @show = FactoryBot.create(:show)
  end

  test "should get index" do
    get shows_url
    assert_response :success
  end

  test "should show show" do
    get show_url(@show)
    assert_response :success
  end
end
