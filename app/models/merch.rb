class Merch < ApplicationRecord
  include Deactivatable

  serialize :options, type: Array, coder: JSON

  validates :order, presence: true, numericality: { greater_than_or_equal_to: 0 }
  before_commit -> { self.order = Merch.maximum(:order).to_i + 1 }, on: :create

  has_one_attached :image do |image|
    image.variant :medium, resize_to_limit: [600, 600], format: :webp, convert: :webp
  end
  scope :includes_image, -> { includes(image_attachment: :blob) }
  validates :image, attached: true

  has_and_belongs_to_many :categories,
                          class_name: "Merch::Category",
                          association_foreign_key: :merch_category_id,
                          foreign_key: :merch_id,
                          join_table: :merch_merch_categories
  accepts_nested_attributes_for :categories

  has_many :order_merch, class_name: "Order::Merch", inverse_of: :merch

  validates :price, presence: true
  validates :name, presence: true

  def skip_name_suffix
    true
  end
end
