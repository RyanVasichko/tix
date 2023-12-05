class Show::Section < ApplicationRecord
  enum payment_method: TicketType::PAYMENT_METHODS
  enum convenience_fee_type: TicketType::CONVENIENCE_FEE_TYPES

  belongs_to :show, inverse_of: :sections, touch: true
  has_many :seats, class_name: "Show::Seat", inverse_of: :section, foreign_key: "show_section_id"

  validates :ticket_price, presence: true

  def ticket_convenience_fees
    if convenience_fee_type == "flat_rate"
      convenience_fee
    elsif convenience_fee_type == "percentage"
      ((ticket_price * convenience_fee) / 100).round(2)
    end
  end
end
