class User::ShoppingCart
  def initialize(user)
    @user = user
  end

  def total_items
    @user.reserved_seats.count
  end

  def reserved_seats_grouped_by_show
    @user.reserved_seats.group_by(&:show)
  end

  def empty?
    @user.reserved_seats.empty?
  end

  def total_in_cents_for_items_in_cart
    @user.reserved_seats.sum { |s| s.section.ticket_price * 100 }.to_i
  end
end