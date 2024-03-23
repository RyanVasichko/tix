class Ticket < ApplicationRecord
  include Purchaseable, Selectable

  belongs_to :show_section, class_name: "Show::Section", foreign_key: "show_section_id", touch: true
  delegate :convenience_fee_type, :payment_method, :ticket_price, :deposit_payment_method?, to: :show_section
  has_one :show, through: :show_section
end
