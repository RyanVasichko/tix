module ShoppingCartsHelper
  def morph_shopping_cart
    morphs = []
    morphs << turbo_stream.action("morph", "shopping_cart_count") do
      render "shopping_carts/count", shopping_cart: Current.user.shopping_cart
    end

    morphs << turbo_stream.action("morph", "shopping_cart") do
      render "shopping_carts/shopping_cart", shopping_cart: Current.user.shopping_cart
    end

    safe_join(morphs)
  end

  def morph_shopping_cart_and_replace_seat(seat)
    safe_join([morph_shopping_cart, turbo_replace_seat(seat)])
  end
end
