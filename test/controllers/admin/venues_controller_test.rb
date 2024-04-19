require "test_helper"

class VenuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "should get index" do
    venue = FactoryBot.create(:venue)

    get admin_venues_url
    assert_response :success
    assert_includes response.body, venue.name
  end

  test "index should be keyword searchable by name" do
    FactoryBot.create(:venue, name: "Reliant Stadium")
    FactoryBot.create(:venue, name: "Astrodome")

    get admin_venues_url(q: "astro")
    assert_response :success
    assert_includes response.body, "Astrodome"
    refute_includes response.body, "Reliant Stadium"
  end

  test "index should be sortable by name" do
    FactoryBot.create(:venue, name: "Reliant Stadium")
    FactoryBot.create(:venue, name: "Astrodome")

    get admin_venues_url(sort: "name", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "Astrodome"
    assert_select "tbody tr:nth-child(2) td", text: "Reliant Stadium"

    get admin_venues_url(sort: "name", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "Reliant Stadium"
    assert_select "tbody tr:nth-child(2) td", text: "Astrodome"
  end

  test "index should be sortable by active" do
    FactoryBot.create(:venue, name: "Reliant Stadium", active: false)
    FactoryBot.create(:venue, name: "Astrodome")

    get admin_venues_url(sort: "active", sort_direction: "asc", include_deactivated: "1")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "Reliant Stadium"
    assert_select "tbody tr:nth-child(2) td", text: "Astrodome"

    get admin_venues_url(sort: "active", sort_direction: "desc", include_deactivated: "1")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "Astrodome"
    assert_select "tbody tr:nth-child(2) td", text: "Reliant Stadium"
  end

  test "should get new" do
    get new_admin_venue_url, as: :turbo_stream
    assert_response :success
  end

  test "should create venue" do
    assert_difference("Venue.count") do
      post admin_venues_url, params: { venue: { name: "New Venue" } }
    end

    assert_redirected_to admin_venues_url
  end

  test "should get edit" do
    venue = FactoryBot.create(:venue)
    get edit_admin_venue_url(venue), as: :turbo_stream
    assert_response :success
  end

  test "should update venue" do
    venue = FactoryBot.create(:venue)
    patch admin_venue_url(venue), params: { venue: { name: "Updated Venue Name" } }
    assert_redirected_to admin_venues_url

    assert_equal "Updated Venue Name", venue.reload.name
  end

  test "should deactivate venue" do
    venue = FactoryBot.create(:venue)
    assert_difference("Venue.count", 0) do
      delete admin_venue_url(venue)
    end

    assert_redirected_to admin_venues_url
    assert venue.reload.deactivated?
  end
end
