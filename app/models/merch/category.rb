class Merch::Category < ApplicationRecord
  has_and_belongs_to_many :merch,
                          foreign_key: :merch_category_id,
                          association_foreign_key: :merch_id,
                          join_table: :merch_merch_categories

  validates :name, presence: true, uniqueness: true
end
