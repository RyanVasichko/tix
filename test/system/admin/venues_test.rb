require "application_system_test_case"

class VenuesTest < ApplicationSystemTestCase
  setup do
    sign_in FactoryBot.create(:admin)
    @venue = FactoryBot.create(:venue)
  end

  test "visiting the index" do
    visit admin_venues_url
    assert_selector "h1", text: "Venues"
    assert_text @venue.name
  end

  test "should create venue" do
    visit admin_venues_url
    find("#new_venue").click
    fill_in "Name", with: "New Venue Name"
    click_on "Create Venue"

    assert_text "Venue was successfully created"
    assert_equal "New Venue Name", Venue.last.name
  end

  test "should update Venue" do
    visit admin_venues_url
    click_on @venue.name
    fill_in "Name", with: "Updated Venue Name"
    click_on "Update Venue"

    assert_text "Venue was successfully updated"
    assert_equal "Updated Venue Name", @venue.reload.name
  end

  test "should deactivate Venue" do
    visit admin_venues_url
    within "tr", text: @venue.name do
      click_on "Deactivate"
    end

    assert_text "Venue was successfully deactivated"
  end

  test "should activate an inactive Venue" do
    @venue.deactivate!
    visit admin_venues_url
    check "Include deactivated?"
    assert_selector "tbody tr td", text: @venue.name
    within "tr", text: @venue.name do
      click_on "Activate"
    end

    assert_text "Venue was successfully activated"
    assert @venue.reload.active?
  end
end
