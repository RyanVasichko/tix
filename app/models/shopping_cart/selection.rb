class ShoppingCart::Selection < ApplicationRecord
  attribute :quantity, :integer, default: 1
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  belongs_to :shopping_cart, touch: true
  has_one :user, through: :shopping_cart

  delegated_type :selectable, types: %w[Merch Ticket], touch: true
  before_commit -> { selectable.destroy! }, if: -> { selectable.destroyed_with_selection? }, on: :destroy
  before_commit -> { ExpirationJob.set(wait_until: expires_at).perform_later(self) }

  def expired?
    expires_at&.past?
  end

  def transfer_to!(recipient)
    update!(shopping_cart: recipient.shopping_cart)
  end
end
