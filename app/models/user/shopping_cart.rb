class User::ShoppingCart < ApplicationRecord
  has_many :seats, -> { where(reserved_until: Time.current..) }, dependent: :nullify, class_name: "Show::Seat", foreign_key: :user_shopping_cart_id
  has_many :merch, dependent: :destroy, class_name: "User::ShoppingCart::Merch", foreign_key: :user_shopping_cart_id
  has_one :user, inverse_of: :shopping_cart

  default_scope do
    includes(
      seats: [section: [{ show: :artist }]],
      merch: [merch: [{ image_attachment: :blob }]]
    )
  end

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
end
