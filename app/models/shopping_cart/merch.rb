class ShoppingCart::Merch < ApplicationRecord
  delegate :name, to: :merch, prefix: true

  belongs_to :merch, class_name: "::Merch"
  belongs_to :shopping_cart

  def transfer_to!(recipient)
    with_lock { update!(shopping_cart: recipient) }
  end
end
