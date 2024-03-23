module Tickets::ReservedSeating::Selectable
  extend ActiveSupport::Concern

  def select_for!(user)
    return false unless selectable_by(user)
    user.shopping_cart.selections.create! \
      selectable: self,
      expires_at: Time.current + user.ticket_reservation_time
  end

  def cancel_selection_for!(user)
    return false unless selected_by == user
    shopping_cart_selection.destroy!
  end

  private

  def selectable_by(user)
    purchase.blank? && !seat.held? && (selected_by.blank? || selected_by == user)
  end
end
