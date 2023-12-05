require "test_helper"

class ReservedSeatingShowsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    show = FactoryBot.create(:reserved_seating_show)

    get reserved_seating_show_url(show)
    assert_response :success
  end
end
