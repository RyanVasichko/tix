require "application_integration_test_case"

class Admin::ShowsControllerTest < ApplicationIntegrationTestCase
  setup { @show = shows(:radiohead) }

  test "should get index" do
    get admin_shows_path
    assert_response :success
  end

  test "should get new" do
    get new_admin_show_path
    assert_response :success
  end

  test "should create a show" do
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

    assert_difference("Show.count") do
      assert_difference("Show::Section.count", 2) do
        params = {
          artist_id: artists(:radiohead).id,
          seating_chart_id: seating_charts(:full_house).id,
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
          sections_attributes: [
            { seating_chart_section_id: seating_chart_sections(:normal).id, ticket_price: 65.99 },
            { seating_chart_section_id: seating_chart_sections(:obstructed).id, ticket_price: 49.50 }
          ],
          customer_question_ids: [additional_artists_question.id]
        }
        post admin_shows_path, params: { show: params }
      end
    end

    show = Show.last

    refute_nil show
    assert_equal artists(:radiohead), show.artist
    assert_equal seating_charts(:full_house), show.seating_chart
    assert_equal show_date, show.show_date
    assert_equal front_end_on_sale_at, show.front_end_on_sale_at
    assert_equal front_end_off_sale_at, show.front_end_off_sale_at
    assert_equal back_end_on_sale_at, show.back_end_on_sale_at
    assert_equal back_end_off_sale_at, show.back_end_off_sale_at
    assert_equal doors_open_at.to_time, show.doors_open_at
    assert_equal dinner_starts_at, show.dinner_starts_at
    assert_equal dinner_ends_at, show.dinner_ends_at
    assert_equal show_starts_at, show.show_starts_at

    assert_equal 65.99, show.sections.find_by(seating_chart_section: seating_chart_sections(:normal)).ticket_price
    assert_equal 49.50, show.sections.find_by(seating_chart_section: seating_chart_sections(:obstructed)).ticket_price

    assert_equal "Test additional text", show.additional_text
    assert_equal [additional_artists_question], show.customer_questions
  end

  test "should get edit" do
    get edit_admin_show_path(@show)
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

    patch admin_show_path(@show), params: { show: params }

    @show.reload

    assert_equal artists(:lcd_soundsystem), @show.artist
    assert_equal "2025/04/05".to_date, @show.show_date
    assert_equal "2025/04/05 7:45 PM".to_time, @show.show_starts_at
    assert_equal "2025/04/05 9:30 PM".to_time, @show.show_ends_at

    assert_equal 99.50, show_sections(:radiohead_premium).reload.ticket_price
    assert_equal 83.50, show_sections(:radiohead_obstructed).reload.ticket_price
  end

  test "should destroy a show" do
    skip "how are we going to handle delete/deactivation?"
    assert_difference("Show.count", -1) { delete admin_show_path(@show) }

    assert_redirected_to admin_shows_path
  end
end
