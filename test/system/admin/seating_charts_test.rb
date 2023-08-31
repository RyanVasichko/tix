require "application_system_test_case"

class Admin::SeatingChartsTest < ApplicationSystemTestCase
  setup do
    @admin_seating_chart = admin_seating_charts(:one)
  end

  test "visiting the index" do
    visit admin_seating_charts_url
    assert_selector "h1", text: "Seating charts"
  end

  test "should create seating chart" do
    visit admin_seating_charts_url
    click_on "New seating chart"

    click_on "Create Seating chart"

    assert_text "Seating chart was successfully created"
    click_on "Back"
  end

  test "should update Seating chart" do
    visit admin_seating_chart_url(@admin_seating_chart)
    click_on "Edit this seating chart", match: :first

    click_on "Update Seating chart"

    assert_text "Seating chart was successfully updated"
    click_on "Back"
  end

  test "should destroy Seating chart" do
    visit admin_seating_chart_url(@admin_seating_chart)
    click_on "Destroy this seating chart", match: :first

    assert_text "Seating chart was successfully destroyed"
  end
end
