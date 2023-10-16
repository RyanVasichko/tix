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
    show_date = Time.current.change(month: 4, day: 5, hour: 0, min: 0, sec: 0) + 1.year
    front_end_on_sale_at = show_date.change(month: 3, day: 5, hour: 8, min: 0, sec: 0)
    front_end_off_sale_at = show_date.change(month: 4, day: 20, hour: 21, min: 0, sec: 0)
    back_end_on_sale_at = show_date.change(month: 3, day: 19, hour: 9, min: 0, sec: 0)
    back_end_off_sale_at = show_date.change(month: 4, day: 20, hour: 22, min: 0, sec: 0)
    doors_open_at = show_date.change(hour: 18)
    dinner_starts_at = show_date.change(hour: 18, min: 15)
    dinner_ends_at = show_date.change(hour: 19, min: 30)
    show_starts_at = show_date.change(hour: 20)
    additional_artists_question = customer_questions(:additional_artists)

    assert_difference "Show.count" do
      assert_difference "Show::Section.count", 2 do
        visit admin_shows_url
        click_on "New Show"

        fill_in "Artist", with: "Radi"
        find("li[data-combobox-option-label-param='Radiohead']").click

        select "Full House", from: "Seating chart"
        fill_in "show_sections_attributes_#{@obstructed_section.id}_ticket_price", with: "23.50"
        fill_in "show_sections_attributes_#{@normal_section.id}_ticket_price", with: "45"

        fill_in "Show date", with: show_date.to_formatted_s(:date_field)
        fill_in "Doors open at", with: doors_open_at.to_formatted_s(:time_field)
        fill_in "Dinner starts at", with: dinner_starts_at.to_formatted_s(:time_field)
        fill_in "Dinner ends at", with: dinner_ends_at.to_formatted_s(:time_field)
        fill_in "Show starts at", with: show_starts_at.to_formatted_s(:time_field)

        fill_in "Back end on sale at", with: back_end_on_sale_at.to_formatted_s(:datetime_field)
        fill_in "Back end off sale at", with: back_end_off_sale_at.to_formatted_s(:datetime_field)
        fill_in "Front end on sale at", with: front_end_on_sale_at.to_formatted_s(:datetime_field)
        fill_in "Front end off sale at", with: front_end_off_sale_at.to_formatted_s(:datetime_field)

        fill_in "Additional text", with: "This is some additional text"
        check additional_artists_question.question

        click_on "Add Upsale"
        within "#show_upsales_fields" do
          fill_in "Name", with: "VIP Parking"
          fill_in "Description", with: "Park closer to the venue"
          fill_in "Quantity", with: "10"
          fill_in "Price", with: "10"
        end

        click_on "Create Show"

        assert_text "Show was successfully created"
      end
    end

    created_show = Show.last

    assert_equal artists(:radiohead), created_show.artist
    assert_equal seating_charts(:full_house), created_show.seating_chart
    assert_equal "This is some additional text", created_show.additional_text

    assert_equal show_date, created_show.show_date
    assert_equal show_starts_at, created_show.show_starts_at
    assert_equal doors_open_at, created_show.doors_open_at
    assert_equal dinner_starts_at, created_show.dinner_starts_at
    assert_equal dinner_ends_at, created_show.dinner_ends_at

    assert_equal back_end_on_sale_at, created_show.back_end_on_sale_at
    assert_equal back_end_off_sale_at, created_show.back_end_off_sale_at
    assert_equal front_end_on_sale_at, created_show.front_end_on_sale_at
    assert_equal front_end_off_sale_at, created_show.front_end_off_sale_at

    assert_equal 23.50, created_show.sections.find_by(seating_chart_section: @obstructed_section).ticket_price
    assert_equal 45, created_show.sections.find_by(seating_chart_section: @normal_section).ticket_price

    assert_equal 1, created_show.upsales.count
    created_upsale = created_show.upsales.first
    assert_equal "VIP Parking", created_upsale.name
    assert_equal "Park closer to the venue", created_upsale.description
    assert_equal 10, created_upsale.quantity
    assert_equal 10, created_upsale.price

    assert_equal 1, created_show.customer_questions.count
    assert_equal additional_artists_question, created_show.customer_questions.first
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

    assert_equal Time.zone.parse("2024/04/05 7:30PM"), @show.show_starts_at
    assert_equal Time.zone.parse("2024/04/05 9:00PM"), @show.show_ends_at
    assert_equal Date.strptime("04/05/2024", "%m/%d/%Y"), @show.show_date
  end

  test "should create an artist from the shows form" do
    visit new_admin_show_url
    click_on "Add Artist"

    assert_difference "Artist.count" do
      within "#admin_artist_form" do
        fill_in "Name", with: "The Beatles"
        fill_in "Bio", with: "The Beatles were an English rock band formed in Liverpool in 1960."
        fill_in "Url", with: "https://www.thebeatles.com/"
        attach_file('artist_image', Rails.root.join('test/fixtures/files/radiohead.jpg'))
        click_on "Create Artist"
      end

      assert_text "Artist was successfully created."

      created_artist = Artist.last
      assert_equal "The Beatles", created_artist.name
      assert_equal "The Beatles were an English rock band formed in Liverpool in 1960.", created_artist.bio
      assert_equal "https://www.thebeatles.com/", created_artist.url
      assert created_artist.image.attached?
    end

    fill_in "Artist", with: "The Bea"
    assert_text "The Beatles"
  end

  test "should destroy Show" do
    skip "how is deleting/taking a show offsale supposed to be handled?"
    visit admin_show_url(@show)
    click_on "Destroy this show", match: :first

    assert_text "Show was successfully destroyed"
  end
end
