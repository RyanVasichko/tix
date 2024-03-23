module Show::Seat::Selectable
  extend ActiveSupport::Concern

  included do
    has_one :shopping_cart_selection, class_name: "ShoppingCart::Selection", through: :ticket
    delegate :expires_at, to: :shopping_cart_selection, prefix: true, allow_nil: true

    has_one :shopping_cart, class_name: "ShoppingCart", through: :shopping_cart_selection, source: :shopping_cart
    has_one :selected_by, class_name: "User", through: :shopping_cart, source: :user
    delegate :shopper_uuid, to: :selected_by, prefix: true, allow_nil: true

    scope :selected_by, ->(user) { joins(:selected_by).where(selected_by: { id: user }) }
    scope :selected, -> { joins(:selected_by) }
    scope :not_selected, -> { where.missing(:selected_by) }
  end
end
