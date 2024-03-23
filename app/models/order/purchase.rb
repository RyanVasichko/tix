class Order::Purchase < ApplicationRecord
  belongs_to :order
  delegate :orderer, to: :order

  delegated_type :purchaseable, types: %w[Merch Ticket]

  def self.build_from_shopping_cart_selections(selections)
    selections.map do |selection|
      build(purchaseable: selection.selectable,
            quantity: selection.quantity,
            options: selection.options)
        .tap(&:calculate_pricing)
    end
  end

  def calculate_pricing
    self.item_price = purchaseable.item_price
    self.total_price = purchaseable.total_price(quantity:)
    self.balance_paid = purchaseable.amount_due_at_purchase(quantity:)
    self.total_fees = purchaseable.total_fees(quantity:)
  end
end
