require "test_helper"

class Shows::ReservedSeating::TicketSelectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:customer)
    sign_in @user
    @ticket = FactoryBot.create(:show_seat).ticket
  end

  test "create should select the ticket when not selected or sold, or when the seat is not held" do
    post shows_reserved_seating_seat_ticket_selections_url(@ticket.seat.show, @ticket.seat), as: :turbo_stream

    assert_response :success
    assert_equal @user, @ticket.reload.selected_by
  end

  test "create should not select the ticket when reserved by another user" do
    @ticket.select_for!(FactoryBot.create(:customer))

    post shows_reserved_seating_seat_ticket_selections_url(@ticket.seat.show, @ticket.seat), as: :turbo_stream
    assert_not_equal @user, @ticket.reload.selected_by
  end

  test "create should select the ticket when another user's selection has expired" do
    @ticket.select_for!(FactoryBot.create(:customer))
    @ticket.shopping_cart_selection.update!(expires_at: Time.current - 1.day)

    post shows_reserved_seating_seat_ticket_selections_url(@ticket.seat.show, @ticket.seat), as: :turbo_stream

    assert_response :success
    assert_equal @user, @ticket.reload.selected_by
  end

  test "create should not select the ticket when the seat is held" do
    admin = FactoryBot.create(:admin)
    @ticket.select_for!(admin)
    @ticket.seat.reload.hold_for!(admin)
    assert @ticket.seat.held?

    post shows_reserved_seating_seat_ticket_selections_url(@ticket.seat.show, @ticket.seat), as: :turbo_stream

    assert_response :success
    assert_not_equal @user, @ticket.reload.selected_by
  end

  test "create should not select the ticket when sold" do
    FactoryBot.create(:order_reserved_seating_ticket_purchase, purchaseable: @ticket)

    post shows_reserved_seating_seat_ticket_selections_url(@ticket.seat.show, @ticket.seat), as: :turbo_stream
    assert_response :success

    assert_not_equal @user, @ticket.reload.selected_by
  end
end
