class Order < ApplicationRecord
  include Shippable, Billable, Searches, Searchable

  belongs_to :orderer, polymorphic: true
  delegate :name, :phone, :email, to: :orderer, prefix: true

  has_many :purchases, class_name: "Order::Purchase"
  scope :includes_purchases, -> { includes(purchases: :purchaseable) }

  has_many :tickets, through: :purchases, source: :purchaseable, source_type: "Ticket"

  has_many :shows, through: :tickets, source: :show
  scope :includes_show, -> { includes(shows: :artist) }

  before_commit :set_order_number, on: :create, unless: -> { order_number.present? }

  def self.build_from_shopping_cart_selections(shopping_cart_selections)
    build do |order|
      order.purchases << Order::Purchase.build_from_shopping_cart_selections(shopping_cart_selections)
      order.calculate_order_totals
    end
  end

  def total_fees
    purchases.sum(:total_fees)
  end

  def tickets_count
    purchases.tickets.sum(:quantity)
  end

  private

  def set_order_number
    this_month_and_year = Date.today.strftime("%b%y").upcase
    padded_id = id.to_s.rjust(5, "0")
    update(order_number: "#{this_month_and_year}#{padded_id}")
  end
end
