class CustomerQuestion < ApplicationRecord
  include Deactivatable

  validates :question, presence: true

  has_and_belongs_to_many :shows
end
