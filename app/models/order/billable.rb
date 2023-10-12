module Order::Billable
  extend ActiveSupport::Concern

  def total_in_cents
    return (order_total * 100).to_i
  end

  def calculate_order_total
    self.order_total = tickets.sum(&:price) + merch.sum(&:total_price)
  end
end
