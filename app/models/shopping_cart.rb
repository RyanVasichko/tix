class ShoppingCart < ApplicationRecord
  after_update_commit :broadcast_updates

  has_many :selections, dependent: :destroy, class_name: "ShoppingCart::Selection", foreign_key: :shopping_cart_id
  has_many :ticket_selections, -> { where(selectable_type: "Ticket") }, class_name: "ShoppingCart::Selection", foreign_key: :shopping_cart_id
  has_one :user

  def adjust_ticket_selections_for!(show_section_id:, quantity:)
    ticket = Tickets::GeneralAdmission.find_or_initialize_for_show_section_and_shopping_cart(user, show_section_id)
    selection = ticket_selections.find_or_initialize_by(selectable: ticket)

    if quantity.zero?
      selection.destroy! if selection.persisted?
    else
      selection.update!(quantity: quantity)
    end
  end

  def find_or_initialize_ticket_selections_for_show_section(show_section_id)
    ticket = Tickets::GeneralAdmission.find_or_initialize_for_show_section_and_shopping_cart(self, show_section_id)
    ticket_selections.find_or_initialize_by(selectable: ticket) { |s| s.quantity = 0 }
  end

  def size
    selections.sum(:quantity)
  end

  def empty!
    selections.each(&:destroy!)
  end

  def empty?
    selections.empty?
  end

  def transfer_selections_to(recipient)
    ActiveRecord::Base.transaction do
      selections.each { |s| s.transfer_to!(recipient) }
    end
  end

  private

  def broadcast_updates
    broadcast_action_later action: :morph,
                           target: "shopping_cart",
                           partial: "shopping_carts/shopping_cart",
                           locals: {
                             shopping_cart: self
                           }

    broadcast_action_later action: :morph,
                           target: "shopping_cart_count",
                           partial: "shopping_carts/count",
                           locals: {
                             shopping_cart: self
                           }
  end
end
