require "test_helper"

class TicketTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "should get index" do
    ticket_type = FactoryBot.create(:ticket_type)
    get admin_ticket_types_url
    assert_response :success
    assert_includes response.body, ticket_type.name
  end

  test "index should be keyword searchable" do
    FactoryBot.create(:ticket_type, name: "VIP")
    FactoryBot.create(:ticket_type, name: "General Admission")

    get admin_ticket_types_url(q: "gener")
    assert_response :success
    assert_includes response.body, "General Admission"
    refute_includes response.body, "VIP"
  end

  test "index should be orderable by name" do
    FactoryBot.create(:ticket_type, name: "VIP")
    FactoryBot.create(:ticket_type, name: "General Admission")

    get admin_ticket_types_url(sort: "name", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "General Admission"
    assert_select "tbody tr:nth-child(2) td", text: "VIP"

    get admin_ticket_types_url(sort: "name", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "VIP"
    assert_select "tbody tr:nth-child(2) td", text: "General Admission"
  end

  test "index should be orderable by venue name" do
    astrodome = FactoryBot.create(:venue, name: "Astrodome", ticket_types_count: 1)
    reliant_stadium = FactoryBot.create(:venue, name: "Reliant Stadium", ticket_types_count: 1)

    get admin_ticket_types_url(sort: "venue_name", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: astrodome.ticket_types.first.name
    assert_select "tbody tr:nth-child(2) td", text: reliant_stadium.ticket_types.first.name

    get admin_ticket_types_url(sort: "venue_name", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: reliant_stadium.ticket_types.first.name
    assert_select "tbody tr:nth-child(2) td", text: astrodome.ticket_types.first.name
  end

  test "index should be orderable by convenience fee type" do
    FactoryBot.create(:ticket_type, name: "VIP", convenience_fee_type: "percentage")
    FactoryBot.create(:ticket_type, name: "General Admission", convenience_fee_type: "flat_rate")

    get admin_ticket_types_url(sort: "convenience_fee_type", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "General Admission"
    assert_select "tbody tr:nth-child(2) td", text: "VIP"

    get admin_ticket_types_url(sort: "convenience_fee_type", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "VIP"
    assert_select "tbody tr:nth-child(2) td", text: "General Admission"
  end

  test "index should be orderable by payment method" do
    FactoryBot.create(:ticket_type, name: "VIP", payment_method: "deposit")
    FactoryBot.create(:ticket_type, name: "General Admission", payment_method: "cover")

    get admin_ticket_types_url(sort: "payment_method", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "General Admission"
    assert_select "tbody tr:nth-child(2) td", text: "VIP"

    get admin_ticket_types_url(sort: "payment_method", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "VIP"
    assert_select "tbody tr:nth-child(2) td", text: "General Admission"
  end

  test "index should be orderable by active" do
    FactoryBot.create(:ticket_type, name: "VIP")
    FactoryBot.create(:ticket_type, name: "General Admission", active: false)

    get admin_ticket_types_url(sort: "active", sort_direction: "asc", include_deactivated: "1")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "General Admission"
    assert_select "tbody tr:nth-child(2) td", text: "VIP"

    get admin_ticket_types_url(sort: "active", sort_direction: "desc", include_deactivated: "1")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "VIP"
    assert_select "tbody tr:nth-child(2) td", text: "General Admission"
  end

  test "should get new" do
    get new_admin_ticket_type_url
    assert_response :success
  end

  test "should create ticket_type" do
    ticket_type_params
    assert_difference("TicketType.count") do
      post admin_ticket_types_url, params: { ticket_type: ticket_type_params }
    end

    assert_redirected_to admin_ticket_types_url

    assert TicketType.where(ticket_type_params).exists?
  end

  test "should get edit" do
    ticket_type = FactoryBot.create(:ticket_type)
    get edit_admin_ticket_type_url(ticket_type)
    assert_response :success
  end

  test "should update ticket_type" do
    ticket_type = FactoryBot.create(:ticket_type)
    venue_id_was = ticket_type.venue_id
    patch admin_ticket_type_url(ticket_type), params: { ticket_type: ticket_type_params }

    assert_redirected_to admin_ticket_types_url

    ticket_type_params.delete(:venue_id)
    ticket_type.reload
    ticket_type_params.each do |key, value|
      assert_equal value, ticket_type.send(key), "Expected #{key} to be #{value}, but was #{ticket_type.send(key)}"
    end

    assert_equal venue_id_was, ticket_type.venue_id
  end

  test "should deactivate ticket_type" do
    ticket_type = FactoryBot.create(:ticket_type)
    assert_difference("TicketType.count", 0) do
      delete admin_ticket_type_url(ticket_type)
    end

    assert_redirected_to admin_ticket_types_url
    assert ticket_type.reload.deactivated?
  end

  private

  def ticket_type_params
    @ticket_type_params ||= {
      convenience_fee: 13.50,
      convenience_fee_type: "flat_rate",
      default_price: 18.25,
      dinner_included: false,
      name: "New Ticket Type",
      payment_method: "cover",
      venue_commission: 1.25,
      venue_id: FactoryBot.create(:venue).id
    }
  end
end
