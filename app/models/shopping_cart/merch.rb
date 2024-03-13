class ShoppingCart::Merch < ApplicationRecord
  delegate :name, to: :merch, prefix: true

  belongs_to :merch, class_name: "::Merch"
  belongs_to :shopping_cart

  def transfer!(from:, to:)
    return unless shopping_cart == from

    with_lock { update(shopping_cart: to) }
  end
end
