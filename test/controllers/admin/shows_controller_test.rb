require "application_integration_test_case"

class Admin::ShowsControllerTest < ApplicationIntegrationTestCase
  setup { @show = shows(:radiohead) }

  test "should get index" do
    get admin_shows_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_show_url
    assert_response :success
  end

  test "should create a show" do
    assert_difference("Show.count") do
      assert_difference("Show::Section.count", 2) do
        params = {
          artist_id: artists(:radiohead).id,
          seating_chart_id: seating_charts(:full_house).id,
          show_date: "2025/04/05",
          start_time: "7:45 PM",
          end_time: "9:30 PM",
          sections_attributes: [
            { seating_chart_section_id: seating_chart_sections(:normal).id, ticket_price: 65.99 },
            { seating_chart_section_id: seating_chart_sections(:obstructed).id, ticket_price: 49.50 }
          ]
        }
        post admin_shows_url, params: { show: params }
      end
    end

    show = Show.last

    refute_nil show
    assert_equal artists(:radiohead), show.artist
    assert_equal seating_charts(:full_house), show.seating_chart
    assert_equal "2025/04/05".to_date, show.show_date
    assert_equal "2025/04/05 7:45 PM".to_time, show.start_time
    assert_equal "2025/04/05 9:30 PM".to_time, show.end_time
  end

  test "should get edit" do
    get edit_admin_show_url(@show)
    assert_response :success
  end

  test "should update a show" do
    skip "what all should you be allowed to update on a show?"
    params = {
      artist_id: artists(:lcd_soundsystem).id,
      show_date: "2025/04/05",
      start_time: "7:45 PM",
      end_time: "9:30 PM",
      sections_attributes: [
        { id: show_sections(:radiohead_normal).id, ticket_price: 99.50 },
        { id: show_sections(:radiohead_obstructed).id, ticket_price: 83.50 }
      ]
    }

    patch admin_show_url(@show), params: { show: params }

    @show.reload

    assert_equal artists(:lcd_soundsystem),  @show.artist
    assert_equal "2025/04/05".to_date, @show.show_date
    assert_equal "2025/04/05 7:45 PM".to_time, @show.start_time
    assert_equal "2025/04/05 9:30 PM".to_time, @show.end_time

    assert_equal 99.50, show_sections(:radiohead_normal).reload.ticket_price
    assert_equal 83.50, show_sections(:radiohead_obstructed).reload.ticket_price
  end

  test "should destroy a show" do
    skip "how are we going to handle delete/deactivation?"
    assert_difference("Show.count", -1) { delete admin_show_url(@show) }

    assert_redirected_to admin_shows_url
  end
end
