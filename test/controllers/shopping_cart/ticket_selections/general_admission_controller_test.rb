require "test_helper"

class ShoppingCart::TicketSelections::GeneralAdmissionControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:customer, general_admission_tickets_count: 1)
    sign_in @user
  end

  test "update should update the user's general admission ticket selections" do
    general_admission_ticket_selection = @user.shopping_cart.ticket_selections.first

    patch shopping_cart_ticket_selections_general_admission_url(general_admission_ticket_selection),
          params: {
            shopping_cart_selection: { quantity: 2 }
          }
    assert_response :redirect

    assert_equal 2, general_admission_ticket_selection.reload.quantity
  end

  test "update should not update general admission ticket selections for another user" do
    general_admission_ticket_selection = FactoryBot.create(:shopping_cart_general_admission_ticket_selection)
    assert_not_equal @user, general_admission_ticket_selection.user

    assert_raises(ActiveRecord::RecordNotFound) do
      patch shopping_cart_ticket_selections_general_admission_url(general_admission_ticket_selection),
            params: {
              shopping_cart_selection: { quantity: 2 }
            }
    end
  end

  test "destroy should destroy the users general admission ticket selections" do
    general_admission_ticket_selection = @user.shopping_cart.ticket_selections.first

    delete shopping_cart_ticket_selections_general_admission_url(general_admission_ticket_selection)
    assert_response :redirect

    assert_not @user.shopping_cart.ticket_selections.exists?(general_admission_ticket_selection.id)
  end

  test "destroy should not destroy general admission ticket selections for another user" do
    general_admission_ticket_selection = FactoryBot.create(:shopping_cart_general_admission_ticket_selection)
    assert_not_equal @user, general_admission_ticket_selection.user

    assert_raises(ActiveRecord::RecordNotFound) do
      delete shopping_cart_ticket_selections_general_admission_url(general_admission_ticket_selection)
    end
  end
end
