module Order::Billable
  extend ActiveSupport::Concern

  included do
    validates :order_total, presence: true
  end

  def total_in_cents
    (order_total * 100).to_i
  end

  def calculate_order_total
    self.order_total = tickets.sum(&:price) + merch.sum(&:total_price)
  end
end
