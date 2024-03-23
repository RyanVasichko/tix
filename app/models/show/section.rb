class Show::Section < ApplicationRecord
  enum :payment_method, TicketType.payment_methods, suffix: true, validate: true
  enum :convenience_fee_type, TicketType.convenience_fee_types, suffix: true, validate: true

  validates :name, presence: true, uniqueness: { scope: :show_id }
  validates :ticket_price, presence: true

  belongs_to :show, inverse_of: :sections, touch: true

  has_many :tickets, inverse_of: :show_section
end
