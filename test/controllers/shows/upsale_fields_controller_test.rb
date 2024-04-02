require "test_helper"

class UpsaleFieldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "should get new" do
    get new_admin_shows_upsale_fields_url, as: :turbo_stream
    assert_response :success
  end
end
