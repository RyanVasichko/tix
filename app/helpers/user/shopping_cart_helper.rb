module User::ShoppingCartHelper
  def morph_shopping_cart
    concat(turbo_stream.action("morph", "shopping_cart_count") do
      render "shopping_cart/count", shopping_cart: Current.user.shopping_cart_with_items
    end)

    concat(turbo_stream.action("morph", "shopping_cart") do
      render "shopping_cart/shopping_cart", shopping_cart: Current.user.shopping_cart_with_items
    end)
  end

  def morph_shopping_cart_and_replace_seat(seat)
    morph_shopping_cart
    concat(turbo_stream.replace(dom_id(seat)) do
      render partial: "reserved_seating_shows/seats/seat", collection: [seat], as: :seat, cached: true
    end)
  end
end
