class User::Admin < User
  include Authenticateable

  def order_form_type
    Order::AdminOrderForm
  end
end
