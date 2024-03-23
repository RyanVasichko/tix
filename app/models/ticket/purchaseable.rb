module Ticket::Purchaseable
  extend ActiveSupport::Concern

  included do
    has_one :purchase, class_name: "Order::Purchase", as: :purchaseable
    scope :sold, -> { joins(:purchase) }
    scope :not_sold, -> { where.missing(:purchase) }
    has_one :order, through: :purchase

    delegate :shopper_uuid, to: :purchaser, prefix: true, allow_nil: true
  end

  def item_price
    show_section.ticket_price
  end

  def total_fees(quantity:)
    (convenience_fees + show_section.venue_commission) * quantity
  end

  def amount_due_at_purchase(quantity:)
    total_fees(quantity:) + (deposit_payment_method? ? show.deposit_amount : show_section.ticket_price) * quantity
  end

  def total_price(quantity:)
    item_price * quantity + total_fees(quantity:)
  end

  def purchaser
    order&.orderer
  end

  private

  def convenience_fees
    case convenience_fee_type
    when "flat_rate"
      show_section.convenience_fee
    when "percentage"
      ((show_section.ticket_price * show_section.convenience_fee) / 100).round(2)
    end
  end
end
