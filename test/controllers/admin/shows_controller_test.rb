require "application_integration_test_case"

class Admin::ShowsControllerTest < ApplicationIntegrationTestCase
  setup { @reserved_seating_show = FactoryBot.create(:reserved_seating_show) }

  test "should get index" do
    get admin_shows_path
    assert_response :success
  end

  test "should get new" do
    FactoryBot.create(:seating_chart)
    get new_admin_show_path
    assert_response :success
  end

  test "should create a reserved seating show" do
    show_date = Time.current.change(month: 4, day: 5, hour: 0, min: 0, sec: 0) + 1.year
    front_end_on_sale_at = show_date.change(month: 3, day: 5, hour: 8, min: 0, sec: 0)
    front_end_off_sale_at = show_date.change(month: 4, day: 20, hour: 21, min: 0, sec: 0)
    back_end_on_sale_at = show_date.change(month: 3, day: 19, hour: 9, min: 0, sec: 0)
    back_end_off_sale_at = show_date.change(month: 4, day: 20, hour: 22, min: 0, sec: 0)
    doors_open_at = show_date.change(hour: 18)
    dinner_starts_at = show_date.change(hour: 18, min: 15)
    dinner_ends_at = show_date.change(hour: 19, min: 30)
    show_starts_at = show_date.change(hour: 20)

    customer_question = FactoryBot.create(:customer_question)
    artist = FactoryBot.create(:artist)
    venue = FactoryBot.create(:venue)
    seating_chart = FactoryBot.create(:seating_chart, sections_count: 2, venue: venue)
    section_1 = seating_chart.sections.first
    section_2 = seating_chart.sections.second

    expected_differences = {
      "Show.count" => 1,
      "Show::Section.count" => 2
    }
    assert_difference(expected_differences) do
      params = {
        artist_id: artist.id,
        seating_chart_id: seating_chart.id,
        show_date: show_date.strftime("%Y/%m/%d"),
        doors_open_at: doors_open_at.strftime("%l:%M%p"),
        dinner_starts_at: dinner_starts_at.strftime("%l:%M%p"),
        dinner_ends_at: dinner_ends_at.strftime("%l:%M%p"),
        show_starts_at: show_starts_at.strftime("%l:%M%p"),
        front_end_on_sale_at: front_end_on_sale_at.strftime("%Y-%m-%dT%H:%M"),
        front_end_off_sale_at: front_end_off_sale_at.strftime("%Y-%m-%dT%H:%M"),
        back_end_on_sale_at: back_end_on_sale_at.strftime("%Y-%m-%dT%H:%M"),
        back_end_off_sale_at: back_end_off_sale_at.strftime("%Y-%m-%dT%H:%M"),
        additional_text: "Test additional text",
        venue_id: venue.id,
        sections_attributes: [
          { seating_chart_section_id: section_1.id, ticket_price: 65.99 },
          { seating_chart_section_id: section_2.id, ticket_price: 49.50 }
        ],
        customer_question_ids: [customer_question.id],
        type: Show::ReservedSeatingShow.to_s
      }
      post admin_shows_path, params: { show: params }

      assert_redirected_to admin_shows_path
    end

    show = Show::ReservedSeatingShow.last

    refute_nil show
    assert_equal artist, show.artist
    assert_equal seating_chart.name, show.seating_chart_name
    assert_equal show_date, show.show_date
    assert_equal front_end_on_sale_at, show.front_end_on_sale_at
    assert_equal front_end_off_sale_at, show.front_end_off_sale_at
    assert_equal back_end_on_sale_at, show.back_end_on_sale_at
    assert_equal back_end_off_sale_at, show.back_end_off_sale_at
    assert_equal doors_open_at.to_time, show.doors_open_at
    assert_equal dinner_starts_at, show.dinner_starts_at
    assert_equal dinner_ends_at, show.dinner_ends_at
    assert_equal show_starts_at, show.show_starts_at

    assert_equal venue, show.venue
    assert_equal 65.99, show.sections.find_by(name: section_1.name).ticket_price
    assert_equal 49.50, show.sections.find_by(name: section_2.name).ticket_price

    assert_equal "Test additional text", show.additional_text
    assert_equal [customer_question], show.customer_questions
  end

  test "should create a general admission show" do
    show_date = Time.current.change(month: 4, day: 5, hour: 0, min: 0, sec: 0) + 1.year
    front_end_on_sale_at = show_date.change(month: 3, day: 5, hour: 8, min: 0, sec: 0)
    front_end_off_sale_at = show_date.change(month: 4, day: 20, hour: 21, min: 0, sec: 0)
    back_end_on_sale_at = show_date.change(month: 3, day: 19, hour: 9, min: 0, sec: 0)
    back_end_off_sale_at = show_date.change(month: 4, day: 20, hour: 22, min: 0, sec: 0)
    doors_open_at = show_date.change(hour: 18)
    dinner_starts_at = show_date.change(hour: 18, min: 15)
    dinner_ends_at = show_date.change(hour: 19, min: 30)
    show_starts_at = show_date.change(hour: 20)

    customer_question = FactoryBot.create(:customer_question)
    artist = FactoryBot.create(:artist)
    venue = FactoryBot.create(:venue)
    seating_chart = FactoryBot.create(:seating_chart, sections_count: 2, venue: venue)
    section_1 = seating_chart.sections.first
    section_2 = seating_chart.sections.second

    expected_differences = {
      "Show.count" => 1,
      "Show::Section.count" => 2
    }
    assert_difference(expected_differences) do
      params = {
        artist_id: artist.id,
        show_date: show_date.strftime("%Y/%m/%d"),
        doors_open_at: doors_open_at.strftime("%l:%M%p"),
        dinner_starts_at: dinner_starts_at.strftime("%l:%M%p"),
        dinner_ends_at: dinner_ends_at.strftime("%l:%M%p"),
        show_starts_at: show_starts_at.strftime("%l:%M%p"),
        front_end_on_sale_at: front_end_on_sale_at.strftime("%Y-%m-%dT%H:%M"),
        front_end_off_sale_at: front_end_off_sale_at.strftime("%Y-%m-%dT%H:%M"),
        back_end_on_sale_at: back_end_on_sale_at.strftime("%Y-%m-%dT%H:%M"),
        back_end_off_sale_at: back_end_off_sale_at.strftime("%Y-%m-%dT%H:%M"),
        additional_text: "Test additional text",
        venue_id: venue.id,
        sections_attributes: [
          { name: "Section 1", ticket_price: 65.99, convenience_fee: 1.25, ticket_quantity: 50 },
          { name: "Section 2", ticket_price: 49.50, convenience_fee: 2.00, ticket_quantity: 100 }
        ],
        customer_question_ids: [customer_question.id],
        type: Show::GeneralAdmissionShow.to_s
      }
      post admin_shows_path, params: { show: params }

      assert_redirected_to admin_shows_path
    end

    show = Show::GeneralAdmissionShow.last

    refute_nil show
    assert_equal artist, show.artist
    assert_nil show.seating_chart_name
    assert_equal show_date, show.show_date
    assert_equal front_end_on_sale_at, show.front_end_on_sale_at
    assert_equal front_end_off_sale_at, show.front_end_off_sale_at
    assert_equal back_end_on_sale_at, show.back_end_on_sale_at
    assert_equal back_end_off_sale_at, show.back_end_off_sale_at
    assert_equal doors_open_at.to_time, show.doors_open_at
    assert_equal dinner_starts_at, show.dinner_starts_at
    assert_equal dinner_ends_at, show.dinner_ends_at
    assert_equal show_starts_at, show.show_starts_at

    assert_equal venue, show.venue

    section_1 = show.sections.find_by(name: "Section 1")
    section_2 = show.sections.find_by(name: "Section 2")

    assert_equal 65.99, section_1.ticket_price
    assert_equal 49.50, section_2.ticket_price

    assert_equal 1.25, section_1.convenience_fee
    assert_equal 2.00, section_2.convenience_fee

    assert_equal 50, section_1.ticket_quantity
    assert_equal 100, section_2.ticket_quantity

    assert_equal "Test additional text", show.additional_text
    assert_equal [customer_question], show.customer_questions
  end

  test "should get edit" do
    FactoryBot.create(:seating_chart)

    get edit_admin_show_path(@reserved_seating_show)
    assert_response :success
  end

  test "should update a show" do
    skip "what all should you be allowed to update on a show?"
    params = {
      artist_id: artists(:lcd_soundsystem).id,
      show_date: "2025/04/05",
      show_starts_at: "7:45 PM",
      show_ends_at: "9:30 PM",
      sections_attributes: [
        { id: show_sections(:radiohead_premium).id, ticket_price: 99.50 },
        { id: show_sections(:radiohead_obstructed).id, ticket_price: 83.50 }
      ]
    }

    patch admin_show_path(@reserved_seating_show), params: { show: params }

    @reserved_seating_show.reload

    assert_equal artists(:lcd_soundsystem), @reserved_seating_show.artist
    assert_equal "2025/04/05".to_date, @reserved_seating_show.show_date
    assert_equal "2025/04/05 7:45 PM".to_time, @reserved_seating_show.show_starts_at
    assert_equal "2025/04/05 9:30 PM".to_time, @reserved_seating_show.show_ends_at

    assert_equal 99.50, show_sections(:radiohead_premium).reload.ticket_price
    assert_equal 83.50, show_sections(:radiohead_obstructed).reload.ticket_price
  end

  test "should destroy a show" do
    skip "how are we going to handle delete/deactivation?"
    assert_difference("Show.count", -1) { delete admin_show_path(@reserved_seating_show) }

    assert_redirected_to admin_shows_path
  end
end
