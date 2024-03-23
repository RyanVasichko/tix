module Ticket::Selectable
  extend ActiveSupport::Concern

  included do
    has_one :shopping_cart_selection,
            -> { where(expires_at: [nil, Time.current..]) },
            as: :selectable, class_name: "ShoppingCart::Selection"
    has_one :shopping_cart, through: :shopping_cart_selection
    has_one :selected_by, through: :shopping_cart, source: :user

    scope :in_shopping_cart, ->(shopping_cart) { joins(:shopping_cart).where(shopping_cart: { id: shopping_cart }) }
  end

  def destroyed_with_selection?
    false
  end
end
