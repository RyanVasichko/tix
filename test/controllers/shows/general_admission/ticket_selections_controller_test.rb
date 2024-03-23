require "test_helper"

class Shows::GeneralAdmission::TicketSelectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @show = FactoryBot.create(:general_admission_show)
    @user = FactoryBot.create(:customer)
    sign_in @user
  end

  test "new should render the new ticket selection form" do
    get new_shows_general_admission_ticket_selections_path(@show), as: :turbo_stream
    assert_response :success

    assert_select "label", text: @show.sections.first.name
  end

  test "create should add the correct quantities to the shopping cart" do
    assert_difference -> { @user.shopping_cart.ticket_selections.count }, 1 do
      post shows_general_admission_ticket_selections_path(@show), params: {
        shopping_cart_ticket_selections: {
          "0" => { show_section_id: @show.sections.first.id, quantity: 2 }
        }
      }

      assert_redirected_to shows_url
    end

    assert_equal 2, @user.shopping_cart.ticket_selections.first.quantity
  end

  test "create should update the quantity of a ticket already in the shopping cart" do
    existing_shopping_cart_selection = @user.shopping_cart.ticket_selections.create! \
      selectable: Tickets::GeneralAdmission.new(show_section: @show.sections.first),
      quantity: 2

    assert_difference -> { @user.shopping_cart.ticket_selections.count }, 0 do
      post shows_general_admission_ticket_selections_path(@show), params: {
        shopping_cart_ticket_selections: {
          "0" => { show_section_id: existing_shopping_cart_selection.selectable.show_section_id, quantity: 1 }
        }
      }
      assert_redirected_to shows_url
    end

    assert_equal 1, existing_shopping_cart_selection.reload.quantity
  end

  test "create should not add a ticket to the shopping cart if the quantity is 0" do
    assert_no_difference -> { @user.shopping_cart.ticket_selections.count } do
      post shows_general_admission_ticket_selections_path(@show), params: {
        shopping_cart_ticket_selections: {
          "0" => { show_section_id: @show.sections.first.id, quantity: 0 }
        }
      }
      assert_redirected_to shows_url
    end
  end

  test "create should destroy a ticket in the shopping cart if the quantity is 0" do
    existing_shopping_cart_selection = @user.shopping_cart.ticket_selections.create! \
      selectable: Tickets::GeneralAdmission.new(show_section: @show.sections.first),
      quantity: 2

    assert_difference -> { @user.shopping_cart.ticket_selections.count }, -1 do
      post shows_general_admission_ticket_selections_path(@show), params: {
        shopping_cart_ticket_selections: {
          "0" => { show_section_id: existing_shopping_cart_selection.selectable.show_section_id, quantity: 0 }
        }
      }
      assert_redirected_to shows_url
    end
  end
end
