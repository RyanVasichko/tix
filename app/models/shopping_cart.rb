class ShoppingCart < ApplicationRecord
  after_update_commit :broadcast_updates

  before_commit :release_reserved_seats, on: :destroy

  has_many :seats, -> { where(reserved_until: Time.current..) }, dependent: :nullify, class_name: "Show::Seat", foreign_key: :shopping_cart_id
  has_many :tickets, dependent: :destroy, class_name: "ShoppingCart::Ticket", foreign_key: :shopping_cart_id
  has_many :merch, dependent: :destroy, class_name: "ShoppingCart::Merch", foreign_key: :shopping_cart_id
  has_one :user, inverse_of: :shopping_cart

  scope :includes_items, -> {
    includes(
      seats: [section: [{ show: :artist }]],
      merch: [merch: [{ image_attachment: :blob }]]
    )
  }

  def shows
    Show.where(id: seats.joins(:show).select("DISTINCT shows.id")).or(Show.where(id: tickets.joins(:show).select("DISTINCT shows.id")))
  end

  def seats_for(show)
    seats.joins(:show).where(show_sections: { show_id: show.id })
  end

  def tickets_for(show)
    tickets.joins(:show).where(show_sections: { show_id: show.id })
  end

  def total_items
    seats.count + merch.sum(:quantity) + tickets.sum(:quantity)
  end

  def empty?
    seats.empty? && merch.empty? && tickets.empty?
  end

  def transfer_to(recipient)
    ActiveRecord::Base.transaction do
      seats.each { |s| s.transfer_reservation_to!(recipient) }
      merch.each { |m| m.transfer_to!(recipient) }
      destroy!
    end
  end

  private

  def broadcast_updates
    broadcast_action_later action: :morph,
                           target: "shopping_cart",
                           partial: "shopping_cart/shopping_cart",
                           locals: {
                             shopping_cart: self
                           }

    broadcast_action_later action: :morph,
                           target: "shopping_cart_count",
                           partial: "shopping_cart/count",
                           locals: {
                             shopping_cart: self
                           }
  end

  def release_reserved_seats
    seats.each { |seat| seat.cancel_reservation_for!(user) }
  end
end
