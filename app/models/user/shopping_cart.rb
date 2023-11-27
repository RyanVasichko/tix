class User::ShoppingCart < ApplicationRecord
  after_update_commit :broadcast_updates

  has_many :seats, -> { where(reserved_until: Time.current..) }, dependent: :nullify, class_name: "Show::Seat", foreign_key: :user_shopping_cart_id
  has_many :merch, dependent: :destroy, class_name: "User::ShoppingCart::Merch", foreign_key: :user_shopping_cart_id
  has_one :user, inverse_of: :shopping_cart

  scope :includes_items, -> {
    includes(
      seats: [section: [{ show: :artist }]],
      merch: [merch: [{ image_attachment: :blob }]]
    )
  }

  def total_items
    seats.count + merch.sum(:quantity)
  end

  def empty?
    seats.empty? && merch.empty?
  end

  def transfer_to(to)
    ActiveRecord::Base.transaction do
      seats.each { |s| s.transfer_reservation!(from: user, to: to) }
      merch.each { |m| m.transfer!(from: user, to: to) }
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
end
