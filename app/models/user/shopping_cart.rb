class User::ShoppingCart
  def build_merch(merch_params)
    @user.shopping_cart_merch.build(merch_params)
  end

  def merch
    @user.shopping_cart_merch
  end

  def seats
    @user.reserved_seats
  end

  def initialize(user)
    @user = user
  end

  def total_items
    @user.reserved_seats.count + @user.shopping_cart_merch.sum(:quantity)
  end

  def reserved_seats
    @user.reserved_seats
  end

  def empty?
    @user.reserved_seats.empty? && @user.shopping_cart_merch.empty?
  end

  def total_in_cents_for_items_in_cart
    @user.reserved_seats.sum { |s| s.section.ticket_price * 100 }.to_i
  end
end