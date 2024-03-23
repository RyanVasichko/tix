require "test_helper"

class Shows::ReservedSeatingControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    show = FactoryBot.create(:reserved_seating_show)

    get shows_reserved_seating_url(show)
    assert_response :success
  end
end
