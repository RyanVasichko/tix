class CustomerQuestion < ApplicationRecord
  include CanBeDeactivated, Searchable

  has_and_belongs_to_many :shows

  validates :question, presence: true

  orderable_by :question, :active
  scope :keyword_search, ->(query) { where("question LIKE ?", "%#{query}%") }
end
