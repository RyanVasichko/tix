class Show::Sections::GeneralAdmission < Show::Section
  validates :ticket_price, presence: true, numericality: { greater_than: 0 }
  before_validation :set_defaults, on: :create
  has_many :order_tickets, class_name: "Order::Tickets::GeneralAdmission", inverse_of: :show_section, foreign_key: "show_section_id"
  has_many :shopping_cart_tickets, class_name: "ShoppingCart::Ticket", foreign_key: :show_section_id, inverse_of: :show_section

  private

  def set_defaults
    self.payment_method = :cover
    self.convenience_fee_type = :flat_rate
    self.venue_commission = 0
  end
end
