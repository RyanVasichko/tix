class ShoppingCartController < ApplicationController
  def show
    Current.user = User.includes_shopping_cart.find(Current.user.id)
  end
end
