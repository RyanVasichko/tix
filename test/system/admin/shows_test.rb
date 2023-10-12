require "application_system_test_case"

class Admin::ShowsTest < ApplicationSystemTestCase
  setup do
    @show = shows(:lcd_soundsystem)
    @normal_section = seating_chart_sections(:normal)
    @obstructed_section = seating_chart_sections(:obstructed)
  end

  test "visiting the index" do
    visit admin_shows_url
    assert_selector "h1", text: "Shows"
  end

  test "should create show" do
    assert_difference "Show.count" do
      assert_difference "Show::Section.count", 2 do
        visit admin_shows_url
        click_on "New Show"

        select "Radiohead", from: "Artist"
        select "Full House", from: "Seating chart"
        fill_in "show_sections_attributes_#{@obstructed_section.id}_ticket_price", with: "23.50"
        fill_in "show_sections_attributes_#{@normal_section.id}_ticket_price", with: "45"
        fill_in "Show date", with: "4/5/2024"
        fill_in "Start time", with: "7:30PM"
        fill_in "End time", with: "9:00PM"

        click_on "Create Show"

        assert_text "Show was successfully created"
      end
    end

    created_show = Show.last

    assert_equal artists(:radiohead), created_show.artist
    assert_equal seating_charts(:full_house), created_show.seating_chart
    assert_equal Time.zone.parse("2024/04/05 7:30PM"), created_show.start_time
    assert_equal Time.zone.parse("2024/04/05 9:00PM"), created_show.end_time
    assert_equal Date.strptime("04/05/2024", "%m/%d/%Y"), created_show.show_date

    assert_equal 23.50, created_show.sections.find_by(seating_chart_section: @obstructed_section).ticket_price
    assert_equal 45, created_show.sections.find_by(seating_chart_section: @normal_section).ticket_price
  end

  test "should update Show" do
    skip
    visit admins_shows_url
    click_on @show.name

    fill_in "Show date", with: "4/5/2024"
    fill_in "Start time", with: "7:30PM"
    fill_in "End time", with: "9:00PM"

    click_on "Save"
    assert_text "Show was successfully updated"

    @show.reload

    assert_equal Time.zone.parse("2024/04/05 7:30PM"), @show.start_time
    assert_equal Time.zone.parse("2024/04/05 9:00PM"), @show.end_time
    assert_equal Date.strptime("04/05/2024", "%m/%d/%Y"), @show.show_date

  end

  test "should destroy Show" do
    skip "how is deleting/taking a show offsale supposed to be handled?"
    visit admin_show_url(@show)
    click_on "Destroy this show", match: :first

    assert_text "Show was successfully destroyed"
  end
end
