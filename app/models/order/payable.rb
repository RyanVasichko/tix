module Order::Payable
  extend ActiveSupport::Concern

  included do
    belongs_to :payment,
               class_name: "Order::Payment",
               inverse_of: :order,
               foreign_key: :order_payment_id,
               optional: true
  end

  def process_payment(payment_method_id, save_payment_method: false)
    build_payment(stripe_payment_method_id: payment_method_id, amount_in_cents: total_in_cents)
    payment.process(save_payment_method)
  end
end
