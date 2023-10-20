module User::ShoppingCartHelper
  def turbo_stream_replace_shopping_cart_count
    turbo_stream.replace "shopping_cart_count" do
      render "shopping_cart/count", shopping_cart: Current.user.shopping_cart
    end
  end

  def turbo_stream_replace_shopping_cart
    turbo_stream.replace "shopping_cart" do
      render "shopping_cart/shopping_cart", shopping_cart: Current.user.shopping_cart
    end
  end
end
