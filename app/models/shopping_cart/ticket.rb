class ShoppingCart::Ticket < ApplicationRecord
  belongs_to :show_section, class_name: "Show::Sections::GeneralAdmission", inverse_of: :shopping_cart_tickets
  belongs_to :shopping_cart
  has_one :show, through: :show_section

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
