module User::ShoppingCart::BroadcastsUpdates
  extend ActiveSupport::Concern

  included do
    after_update_commit :broadcast_updates
  end

  def broadcast_updates
    broadcast_action_later action: :morph,
                           target: "shopping_cart",
                           partial: "shopping_cart/shopping_cart",
                           locals: {
                             shopping_cart: self
                           }

    broadcast_action_later action: :morph,
                           target: "shopping_cart_count",
                           partial: "shopping_cart/count",
                           locals: {
                             shopping_cart: self
                           }
  end
end
