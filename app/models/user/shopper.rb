module User::Shopper
  extend ActiveSupport::Concern

  included do
    after_initialize :set_shopper_uuid, if: :new_record?
    after_initialize :build_shopping_cart, if: :new_record?
    belongs_to :shopping_cart, class_name: "ShoppingCart", foreign_key: :shopping_cart_id, inverse_of: :user, dependent: :destroy
    has_many :reserved_seats, class_name: "Show::Seat", through: :shopping_cart, source: :seats
    has_many :shopping_cart_merch, class_name: "ShoppingCart::Merch", through: :shopping_cart, source: :merch
  end

  def shopping_cart_with_items
    ShoppingCart.includes_items.find(shopping_cart_id)
  end

  def ticket_reservation_time
    15.minutes
  end

  private

  def set_shopper_uuid
    self.shopper_uuid ||= SecureRandom.uuid
  end
end
