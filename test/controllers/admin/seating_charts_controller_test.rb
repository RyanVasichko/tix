require "test_helper"

class Admin::SeatingChartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "index should display seating charts" do
    FactoryBot.create(:seating_chart, name: "Full House")
    get admin_seating_charts_url

    assert_select "tbody tr td", text: "Full House"
  end

  test "index should sort by name" do
    FactoryBot.create(:seating_chart, name: "Full House")
    FactoryBot.create(:seating_chart, name: "VIP Only")

    get admin_seating_charts_url(sort: "name", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "Full House"
    assert_select "tbody tr:nth-child(2) td", text: "VIP Only"

    get admin_seating_charts_url(sort: "name", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "VIP Only"
    assert_select "tbody tr:nth-child(2) td", text: "Full House"
  end

  test "index should be keyword searchable by name" do
    FactoryBot.create(:seating_chart, name: "Full House")
    FactoryBot.create(:seating_chart, name: "VIP Only")

    get admin_seating_charts_url(q: "ful")
    assert_response :success
    assert_includes response.body, "Full House"
    assert_not_includes response.body, "VIP Only"
  end

  test "should create seating chart with two sections and two seats in each" do
    venue = FactoryBot.create(:venue, ticket_types_count: 2)
    params = {
      seating_chart: {
        name: "Test Seating Chart",
        venue_layout: fixture_file_upload(Rails.root.join("test", "fixtures", "files", "seating_chart.bmp"), "image/bmp"),
        venue_id: venue.id,
        sections_attributes: {
          "0" => {
            name: "Section 1",
            ticket_type_id: venue.ticket_types.first.id,
            seats_attributes: {
              "0" => { seat_number: "1", table_number: "1", x: 10, y: 10 },
              "1" => { seat_number: "2", table_number: "1", x: 20, y: 20 }
            }
          },
          "1" => {
            name: "Section 2",
            ticket_type_id: venue.ticket_types.second.id,
            seats_attributes: {
              "0" => { seat_number: "1", table_number: "2", x: 30, y: 30 },
              "1" => { seat_number: "2", table_number: "2", x: 40, y: 40 }
            }
          }
        }
      }
    }

    post("/admin/seating_charts", params: params, as: :turbo_stream)

    assert_response :redirect

    seating_chart = SeatingChart.last
    assert_equal 2, seating_chart.sections.count
    seating_chart.sections.each do |section|
      assert_equal 2, section.seats.count
    end

    assert_redirected_to admin_seating_charts_url
    assert_equal "Seating chart was successfully created.", flash[:notice]
  end

  test "should destroy a seating chart" do
    seating_chart = FactoryBot.create(:seating_chart)

    delete("/admin/seating_charts/#{seating_chart.id}")

    assert_response :redirect
    assert_redirected_to admin_seating_charts_url
    assert_equal "Seating chart was successfully destroyed.", flash[:notice]
  end

  test "should gracefully handle invalid records" do
    post("/admin/seating_charts", params: { seating_chart: { name: "" } })
    assert_response :unprocessable_entity
  end
end
