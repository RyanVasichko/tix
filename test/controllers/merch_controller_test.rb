require "test_helper"

class MerchControllerTest < ActionDispatch::IntegrationTest
  setup do
    @merch = FactoryBot.create(:merch)
  end

  test "should get index" do
    get merch_index_url
    assert_response :success
  end
end
