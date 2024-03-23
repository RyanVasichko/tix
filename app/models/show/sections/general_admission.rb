class Show::Sections::GeneralAdmission < Show::Section
  has_many :tickets, class_name: "Tickets::GeneralAdmission", inverse_of: :show_section
  validates :ticket_price, presence: true, numericality: { greater_than: 0 }

  before_validation :set_payment_settings, on: :create

  private

  def set_payment_settings
    # General admission shows may only have these options
    self.payment_method = :cover
    self.convenience_fee_type = :flat_rate
    self.venue_commission = 0
  end
end
