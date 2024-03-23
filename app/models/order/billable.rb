module Order::Billable
  extend ActiveSupport::Concern

  included do
    belongs_to :payment, class_name: "Order::Payment", inverse_of: :order, foreign_key: :order_payment_id, optional: true

    validates :balance_paid, presence: true
    validates :total_price, presence: true
    validates :total_fees, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :shipping_charges, presence: true, numericality: { greater_than_or_equal_to: 0 }
  end

  def balance_paid_in_cents
    (balance_paid * 100).to_i
  end

  def calculate_order_totals
    self.shipping_charges = Merch::ShippingRate.for_purchases(purchases.filter(&:merch?))
    self.balance_paid = purchases.sum(&:balance_paid) + shipping_charges
    self.total_price = purchases.sum(&:total_price) + shipping_charges
    self.total_fees = purchases.sum(&:total_fees)
  end

  def process_payment(payment_method_id, save_payment_method: false)
    build_payment(stripe_payment_method_id: payment_method_id, amount_in_cents: balance_paid_in_cents)
    payment.process!(save_payment_method)
  end
end
