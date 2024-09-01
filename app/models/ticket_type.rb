class TicketType < ApplicationRecord
  include CanBeDeactivated, Searchable

  belongs_to :venue
  delegate :name, to: :venue, prefix: true

  enum :payment_method, %w[deposit cover].index_by(&:itself), suffix: true
  enum :convenience_fee_type, %w[flat_rate percentage].index_by(&:itself), suffix: true

  validates :name, presence: true, uniqueness: { scope: :venue_id }
  validates :convenience_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :convenience_fee_type, presence: true
  validates :default_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :venue_commission, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :dinner_included, inclusion: { in: [true, false] }
  validates :active, inclusion: { in: [true, false] }
  validates :payment_method, presence: true

  orderable_by :name, :convenience_fee_type, :payment_method, :active,
               venue: %i[name]

  scope :keyword_search, ->(query) {
    joins(:venue)
      .where(<<~SQL, keyword: "%#{query}%")
        ticket_types.name LIKE :keyword OR
        venues.name LIKE :keyword OR
        ticket_types.convenience_fee_type LIKE :keyword OR
        ticket_types.payment_method LIKE :keyword
      SQL
  }
end
