class Order::Merch < ApplicationRecord
  belongs_to :merch, class_name: "::Merch", foreign_key: :merch_id, inverse_of: :order_merch
  belongs_to :order, inverse_of: :merch

  attr_accessor :shopping_cart_merch
end
