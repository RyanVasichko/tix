class Order::Merch < ApplicationRecord
  belongs_to :merch, class_name: "::Merch", foreign_key: :merch_id, inverse_of: :order_merch
  belongs_to :order, inverse_of: :merch

  attr_accessor :shopping_cart_merch

  def self.build_from_shopping_cart_merch(shopping_cart_merch)
    shopping_cart_merch.map do |scm|
      build(
        merch: scm.merch,
        quantity: scm.quantity,
        unit_price: scm.merch.price,
        total_price: scm.merch.price * scm.quantity,
        option: scm.option,
        option_label: scm.merch.option_label,
        shopping_cart_merch: scm
      )
    end
  end
end
