class Order < ApplicationRecord
  include Payable, Shippable, Billable, BuildableForUser, KeywordSearchable, Searchable

  belongs_to :orderer, polymorphic: true
  delegate :name, :phone, :email, to: :orderer, prefix: true

  has_many :tickets, inverse_of: :order

  has_many :shows, through: :tickets
  has_many :reserved_seating_tickets, class_name: "Order::ReservedSeatingTicket", inverse_of: :order
  has_many :seats, class_name: "Show::Seat", through: :reserved_seating_tickets
  has_many :merch, class_name: "Order::Merch", inverse_of: :order

  before_commit :set_order_number, on: :create

  orderable_by :created_at, :order_total, :order_number
  scope :order_by_orderer_name, ->(direction = :asc) {
    joins(ORDER_SEARCH_INDICES_JOIN).order(Arel.sql("order_search_indices.orderer_name COLLATE NOCASE #{sanitize_sql(direction)}"))
  }

  scope :order_by_orderer_phone, ->(direction = :asc) {
    joins(ORDER_SEARCH_INDICES_JOIN).order(Arel.sql("order_search_indices.orderer_phone COLLATE NOCASE #{sanitize_sql(direction)}"))
  }

  scope :order_by_orderer_email, ->(direction = :asc) {
    joins(ORDER_SEARCH_INDICES_JOIN).order(Arel.sql("order_search_indices.orderer_email COLLATE NOCASE #{sanitize_sql(direction)}"))
 }

  scope :order_by_tickets_count, ->(direction = :asc) {
    joins(ORDER_SEARCH_INDICES_JOIN).order(Arel.sql("order_search_indices.tickets_count #{sanitize_sql(direction)}"))
  }

  def total_fees
    tickets.sum(&:total_fees)
  end

  def tickets_count
    tickets.sum(:quantity) + seats.size
  end

  private

  def set_order_number
    this_month_and_year = Date.today.strftime("%b%y").upcase
    padded_id = id.to_s.rjust(5, "0")
    update(order_number: "#{this_month_and_year}#{padded_id}")
  end
end
