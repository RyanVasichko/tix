class Merch < ApplicationRecord
  include Deactivatable

  has_one_attached :image
  scope :includes_image, -> { includes(image_attachment: :blob) }

  has_and_belongs_to_many :categories,
                          class_name: "Merch::Category",
                          association_foreign_key: :merch_category_id,
                          foreign_key: :merch_id,
                          join_table: :merch_merch_categories
  accepts_nested_attributes_for :categories

  has_many :order_merch, class_name: "Order::Merch", inverse_of: :merch

  validates :price, presence: true
  validates :name, presence: true
  validates :image, attached: true
end
