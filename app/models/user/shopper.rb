module User::Shopper
  extend ActiveSupport::Concern

  included do
    after_initialize :set_shopper_uuid, if: :new_record?

    belongs_to :shopping_cart, class_name: "ShoppingCart", dependent: :destroy
    after_initialize :build_shopping_cart, if: :new_record?
    has_many :shopping_cart_selections, class_name: "ShoppingCart::Selection", through: :shopping_cart, source: :selections
  end

  def ticket_reservation_time
    15.minutes
  end

  private

  def set_shopper_uuid
    self.shopper_uuid ||= SecureRandom.uuid
  end
end
