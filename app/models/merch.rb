class Merch < ApplicationRecord
  include CanBeDeactivated

  serialize :options, type: Array, coder: JSON

  has_one_attached :image do |image|
    image.variant :small, resize_to_limit: [300, 300], format: :webp, convert: :webp, preprocessed: true
    image.variant :medium, resize_to_limit: [600, 600], format: :webp, convert: :webp, preprocessed: true
  end
  validates :image, attached: true

  has_and_belongs_to_many :categories, class_name: "Merch::Category", association_foreign_key: :merch_category_id,
                          foreign_key: :merch_id, join_table: :merch_merch_categories
  accepts_nested_attributes_for :categories
  scope :for_categories, ->(categories) { joins(:categories).where(merch_categories: { id: categories }).group(:id) }

  has_many :purchases, class_name: "Order::Purchase", as: :purchaseable

  has_many :shopping_cart_selections, class_name: "ShoppingCart::Selection", as: :selectable
  before_deactivate :remove_from_shopping_carts

  validates :price, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(active: true) } }
  validates :order, presence: true, numericality: { greater_than_or_equal_to: 0 }
  before_commit :set_order, on: :create

  def item_price
    price
  end

  def total_price(quantity:)
    price * quantity
  end
  alias_method :amount_due_at_purchase, :total_price

  def total_fees(quantity:)
    0
  end

  def destroyed_with_selection?
    false
  end

  private

  def remove_from_shopping_carts
    shopping_cart_selections.each(&:destroy!)
  end

  def set_order
    self.order = Merch.maximum(:order).to_i + 1
  end
end
