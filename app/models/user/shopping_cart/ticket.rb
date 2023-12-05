class User::ShoppingCart::Ticket < ApplicationRecord
  belongs_to :show_section, class_name: "Show::GeneralAdmissionSection", inverse_of: :shopping_cart_tickets
  belongs_to :shopping_cart, class_name: "User::ShoppingCart", inverse_of: :tickets, foreign_key: :user_shopping_cart_id
  has_one :show, through: :show_section

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
