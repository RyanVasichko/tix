require "application_integration_test_case"

class Admin::SeatingChartsControllerTest < ApplicationIntegrationTestCase
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
    assert_equal "Seating chart was successfully created.", flash[:success]
  end

  test "should gracefully handle invalid records" do
    post("/admin/seating_charts", params: { seating_chart: { name: "" } })
    assert_response :unprocessable_entity
  end
end
