require "test_helper"

class TicketTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
    @ticket_type = FactoryBot.create(:ticket_type)
    @ticket_type_params = {
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

  test "should get index" do
    get admin_ticket_types_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_ticket_type_url
    assert_response :success
  end

  test "should create ticket_type" do
    assert_difference("TicketType.count") do
      post admin_ticket_types_url, params: { ticket_type: @ticket_type_params }
    end

    assert_redirected_to admin_ticket_types_url

    assert TicketType.where(@ticket_type_params).exists?
  end

  test "should get edit" do
    get edit_admin_ticket_type_url(@ticket_type)
    assert_response :success
  end

  test "should update ticket_type" do
    venue_id_was = @ticket_type.venue_id
    patch admin_ticket_type_url(@ticket_type), params: { ticket_type: @ticket_type_params }

    assert_redirected_to admin_ticket_types_url

    @ticket_type_params.delete(:venue_id)
    @ticket_type.reload
    @ticket_type_params.each do |key, value|
      assert_equal value, @ticket_type.send(key), "Expected #{key} to be #{value}, but was #{@ticket_type.send(key)}"
    end

    assert_equal venue_id_was, @ticket_type.venue_id
  end

  test "should deactivate ticket_type" do
    assert_difference("TicketType.count", 0) do
      delete admin_ticket_type_url(@ticket_type)
    end

    assert_redirected_to admin_ticket_types_url
    assert @ticket_type.reload.deactivated?
  end
end
