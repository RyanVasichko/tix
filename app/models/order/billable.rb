module Order::Billable
  extend ActiveSupport::Concern

  included do
    validates :order_total, presence: true
  end

  def total_in_cents
    (order_total * 100).to_i
  end

  def calculate_order_total
    self.shipping_fees = Merch::ShippingCharge.for_weight(merch.sum { |m| m.quantity * m.merch.weight })
    self.order_total = tickets.sum(&:total_price) + merch.sum(&:total_price)
    self.convenience_fees = tickets.sum(&:convenience_fees)
  end
end
