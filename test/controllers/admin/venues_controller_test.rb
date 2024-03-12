require "test_helper"

class VenuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @venue = FactoryBot.create(:venue)
  end

  test "should get index" do
    get admin_venues_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_venue_url
    assert_response :success
  end

  test "should create venue" do
    assert_difference("Venue.count") do
      post admin_venues_url, params: { venue: { name: "New Venue" } }
    end

    assert_redirected_to admin_venues_url
  end

  test "should get edit" do
    get edit_admin_venue_url(@venue)
    assert_response :success
  end

  test "should update venue" do
    patch admin_venue_url(@venue), params: { venue: { name: "Updated Venue Name" } }
    assert_redirected_to admin_venues_url

    assert_equal "Updated Venue Name", @venue.reload.name
  end

  test "should deactive venue" do
    assert_difference("Venue.count", 0) do
      delete admin_venue_url(@venue)
    end

    assert_redirected_to admin_venues_url
    assert @venue.reload.deactivated?
  end
end
