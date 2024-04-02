require "test_helper"

class Admin::HomeControllerTest < ActionDispatch::IntegrationTest
  test "index renders" do
    sign_in FactoryBot.create(:admin)
    get admin_url

    assert_response :success
  end
end
