require "application_system_test_case"

class TicketTypesTest < ApplicationSystemTestCase
  setup do
    @ticket_type = FactoryBot.create(:ticket_type, dinner_included: false)
    @ticket_type_params = {
      convenience_fee_type: "flat_rate",
      convenience_fee: "13.50",
      default_price: 18.25,
      dinner_included: false,
      name: "New Ticket Type",
      payment_method: "cover",
      venue_commission: 1.25,
      venue_id: FactoryBot.create(:venue).id
    }
  end

  test "visiting the index" do
    visit admin_ticket_types_url
    assert_selector "h1", text: "Ticket Types"
    assert_text @ticket_type.name
  end

  test "should create ticket type" do
    visit admin_ticket_types_url
    click_on "New Ticket Type"

    assert_difference "TicketType.count" do
      select @ticket_type_params[:convenience_fee_type].humanize, from: "Convenience fee type"
      fill_in "Convenience fee", with: @ticket_type_params[:convenience_fee]
      fill_in "Default price", with: @ticket_type_params[:default_price]
      check "Dinner included" if @ticket_type_params[:dinner_included]
      fill_in "Name", with: @ticket_type_params[:name]
      select @ticket_type_params[:payment_method].humanize, from: "Payment method"
      fill_in "Venue commission", with: @ticket_type_params[:venue_commission]
      select Venue.find(@ticket_type_params[:venue_id]).name, from: "Venue"
      click_on "Create Ticket type"

      assert_text "Ticket type was successfully created"
    end

    assert TicketType.where(@ticket_type_params).exists?
  end

  test "should update Ticket type" do
    visit admin_ticket_types_url
    click_on @ticket_type.name

    select @ticket_type_params[:convenience_fee_type].humanize, from: "Convenience fee type"
    fill_in "Convenience fee", with: @ticket_type_params[:convenience_fee]
    fill_in "Default price", with: @ticket_type_params[:default_price]
    check "Dinner included" if @ticket_type_params[:dinner_included]
    fill_in "Name", with: @ticket_type_params[:name]
    select @ticket_type_params[:payment_method].humanize, from: "Payment method"
    fill_in "Venue commission", with: @ticket_type_params[:venue_commission]
    click_on "Update Ticket type"

    assert_text "Ticket type was successfully updated"

    @ticket_type_params.delete(:venue_id)
    @ticket_type_params.delete(:convenience_fee)
    @ticket_type.reload
    @ticket_type_params.each do |key, value|
      assert_equal value, @ticket_type.send(key), "Expected #{key} to be #{value}, but was #{@ticket_type.send(key)}"
    end
    assert_equal "13.5", @ticket_type.convenience_fee.to_s
  end

  test "should deactivate Ticket type" do
    visit admin_ticket_types_url
    click_on "#{dom_id(@ticket_type, :admin)}_dropdown"
    click_on "Deactivate"

    assert_text "Ticket type was successfully deactivated"
    assert @ticket_type.reload.inactive?
  end
end
