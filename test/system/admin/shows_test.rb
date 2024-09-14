require "application_system_test_case"

class Admin::ShowsTest < ApplicationSystemTestCase
  setup do
    sign_in FactoryBot.create(:admin)
    @show = FactoryBot.create(:reserved_seating_show)
    FactoryBot.create_list(:venue, 3).tap { |venues| @venue = venues.sample }
    @seating_chart = FactoryBot.create(:seating_chart, sections_count: 2, section_seats_count: 2, venue: @venue)
    @section_1 = @seating_chart.sections.first
    @section_2 = @seating_chart.sections.second
  end

  test "visiting the index" do
    visit admin_shows_url
    assert_text @show.artist_name
  end

  test "should create a reserved seating show" do
    set_up_common_fields_for_show_create

    expected_differences = {
      "Show.count" => 1,
      "Show::Section.count" => 2,
      "Show::Seat.count" => 4
    }
    assert_difference expected_differences do
      visit admin_shows_url
      find("#new_show").click

      fill_in_common_fields_for_show_create

      select @seating_chart.name, from: "Seating chart"
      select "Reserved Seating", from: "Type"

      fill_ticket_price_for_section(@section_1.id, 45)
      fill_ticket_price_for_section(@section_2.id, 23.50)

      click_on "Create Show"

      assert_text "Show was successfully created", wait: 15
    end

    created_show = Shows::ReservedSeating.last
    execute_common_assertions_for_show_create(created_show)

    assert_equal @seating_chart.name, created_show.seating_chart_name
    assert_equal @seating_chart.venue_layout.blob, created_show.venue_layout.blob

    assert_equal 23.50, created_show.sections.find_by(name: @section_2.name).ticket_price
    assert_equal 45, created_show.sections.find_by(name: @section_1.name).ticket_price

    assert_equal 4, created_show.seats.count
    @seating_chart.seats.group_by(&:section).each do |section, seats|
      seats.each do |seat|
        expected_seat = created_show.seats.joins(:section).where(
          section: { name: section.name },
          x: seat.x,
          y: seat.y,
          seat_number: seat.seat_number,
          table_number: seat.table_number)

        assert expected_seat.exists?
      end
    end
  end

  test "should create a general admission show" do
    set_up_common_fields_for_show_create

    expected_differences = {
      "Show.count" => 1,
      "Show::Section.count" => 2,
      "Show::Seat.count" => 0
    }
    assert_difference expected_differences do
      visit admin_shows_url
      find("#new_show").click

      select "General Admission", from: "Type"
      fill_in_common_fields_for_show_create

      click_on "Add Section"
      assert_selector ".general_admission_show_section_fields", count: 1
      within all(".general_admission_show_section_fields").last do
        find(".show_section_name_field").set("Section 1")
        find(".show_section_convenience_fee_field").set("2.50")
        find(".show_section_ticket_price_field").set("45")
        find(".show_section_ticket_quantity_field").set("100")
      end

      click_on "Add Section"
      assert_selector ".general_admission_show_section_fields", count: 2
      within all(".general_admission_show_section_fields").last do
        find(".show_section_name_field").set("Section 2")
        find(".show_section_convenience_fee_field").set("3.50")
        find(".show_section_ticket_price_field").set("23.50")
        find(".show_section_ticket_quantity_field").set("75")
      end

      click_on "Create Show"

      assert_text "Show was successfully created"
    end

    created_show = Shows::GeneralAdmission.last
    execute_common_assertions_for_show_create(created_show)

    assert_equal 2, created_show.sections.count

    section_1 = created_show.sections.find_by(name: "Section 1")
    assert_equal 2.50, section_1.convenience_fee
    assert_equal 45, section_1.ticket_price
    assert_equal 100, section_1.ticket_quantity

    section_2 = created_show.sections.find_by(name: "Section 2")
    assert_equal 3.50, section_2.convenience_fee
    assert_equal 23.50, section_2.ticket_price
    assert_equal 75, section_2.ticket_quantity
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

  test "should destroy Show" do
    skip "how is deleting/taking a show offsale supposed to be handled?"
    visit admin_show_url(@show)
    click_on "Destroy this show", match: :first

    assert_text "Show was successfully destroyed"
  end

  private

  def set_up_common_fields_for_show_create
    @artist = FactoryBot.create(:artist)
    @show_date = Time.current.change(month: 4, day: 5, hour: 0, min: 0, sec: 0) + 1.year
    @front_end_on_sale_at = @show_date.change(month: 3, day: 5, hour: 8, min: 0, sec: 0)
    @front_end_off_sale_at = @show_date.change(month: 4, day: 20, hour: 21, min: 0, sec: 0)
    @back_end_on_sale_at = @show_date.change(month: 3, day: 19, hour: 9, min: 0, sec: 0)
    @back_end_off_sale_at = @show_date.change(month: 4, day: 20, hour: 22, min: 0, sec: 0)
    @doors_open_at = @show_date.change(hour: 18)
    @dinner_starts_at = @show_date.change(hour: 18, min: 15)
    @dinner_ends_at = @show_date.change(hour: 19, min: 30)
    @show_starts_at = @show_date.change(hour: 20)
    @customer_question = FactoryBot.create(:customer_question)
  end

  def fill_in_common_fields_for_show_create
    fill_in "Artist", with: @artist.name

    select @venue.name, from: "Venue"

    fill_in "Show date", with: @show_date.to_formatted_s(:date_field)
    fill_in "Doors open at", with: @doors_open_at.to_formatted_s(:time_field)
    fill_in "Dinner starts at", with: @dinner_starts_at.to_formatted_s(:time_field)
    fill_in "Dinner ends at", with: @dinner_ends_at.to_formatted_s(:time_field)
    fill_in "Show starts at", with: @show_starts_at.to_formatted_s(:time_field)

    fill_in "Back end on sale at", with: @back_end_on_sale_at.to_formatted_s(:datetime_field)
    fill_in "Back end off sale at", with: @back_end_off_sale_at.to_formatted_s(:datetime_field)
    fill_in "Front end on sale at", with: @front_end_on_sale_at.to_formatted_s(:datetime_field)
    fill_in "Front end off sale at", with: @front_end_off_sale_at.to_formatted_s(:datetime_field)

    fill_in "Additional text", with: "This is some additional text"
    check @customer_question.question

    click_on "Add Upsale"
    within "#show_upsales_fields" do
      fill_in "Name", with: "VIP Parking"
      fill_in "Description", with: "Park closer to the venue"
      fill_in "Quantity", with: "10"
      fill_in "Price", with: "10"
    end
  end

  def execute_common_assertions_for_show_create(created_show)
    assert_equal @artist, created_show.artist
    assert_equal "This is some additional text", created_show.additional_text

    assert_equal @show_date.to_date, created_show.show_date
    assert_equal @show_starts_at, created_show.show_starts_at
    assert_equal @doors_open_at, created_show.doors_open_at
    assert_equal @dinner_starts_at, created_show.dinner_starts_at
    assert_equal @dinner_ends_at, created_show.dinner_ends_at

    assert_equal @back_end_on_sale_at, created_show.back_end_on_sale_at
    assert_equal @back_end_off_sale_at, created_show.back_end_off_sale_at
    assert_equal @front_end_on_sale_at, created_show.front_end_on_sale_at
    assert_equal @front_end_off_sale_at, created_show.front_end_off_sale_at

    assert_equal 1, created_show.upsales.count
    created_upsale = created_show.upsales.first
    assert_equal "VIP Parking", created_upsale.name
    assert_equal "Park closer to the venue", created_upsale.description
    assert_equal 10, created_upsale.quantity
    assert_equal 10, created_upsale.price

    assert_equal 1, created_show.customer_questions.count
    assert_equal @customer_question, created_show.customer_questions.first
  end

  def fill_ticket_price_for_section(div_id_suffix, price)
    within("#show_section_#{div_id_suffix}_fields") do
      # Using find with XPath to locate the desired input field based on ending substring
      xpath_expression = %{.//input[substring(@name, string-length(@name) - string-length('][ticket_price]') +1) = '][ticket_price]']}
      find(:xpath, xpath_expression).set(price)
    end
  end
end
