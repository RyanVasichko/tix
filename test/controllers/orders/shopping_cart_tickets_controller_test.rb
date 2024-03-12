require "application_integration_test_case"

class Orders::ShoppingCartTicketsControllerTest < ApplicationIntegrationTestCase
  setup do
    user = FactoryBot.create(:customer)
    shopping_cart = FactoryBot.create(:shopping_cart, user: user, general_admission_tickets_count: 1)
    @ticket = shopping_cart.tickets.first
    log_in_as(user)
  end

  test "should destroy ticket" do
    assert_difference("User::ShoppingCart::Ticket.count", -1) do
      delete orders_shopping_cart_ticket_url(@ticket)
    end

    assert_redirected_to new_order_path
  end

  test "should update ticket" do
    new_quantity = @ticket.quantity + 1
    patch orders_shopping_cart_ticket_url(@ticket), params: { quantity: new_quantity }

    @ticket.reload
    assert_equal new_quantity, @ticket.quantity
    assert_redirected_to new_order_path
  end
end
