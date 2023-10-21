class User::Admin < User
  include Authenticateable, Orderer

  def order_form_type
    Order::AdminOrderForm
  end

  def admin?
    true
  end
end
