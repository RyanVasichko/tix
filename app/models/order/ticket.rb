class Order::Ticket < ApplicationRecord
  belongs_to :order, inverse_of: :tickets
  belongs_to :show, inverse_of: :tickets

  validates :convenience_fees, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :venue_commission, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ticket_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }

  def orderer
    order.orderer
  end
end
