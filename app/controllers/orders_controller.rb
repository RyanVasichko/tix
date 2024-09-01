class OrdersController < ApplicationController
  def index
    @orders = Current.user.orders
  end

  def show
    @order = Current.user.orders.find(params[:id])
  end

  def new
    if Current.user.shopping_cart.empty?
      redirect_to \
        root_path,
        flash: { notice: "Your shopping cart is empty, add some items to your shopping cart to check out" }
      return
    end

    @checkout = Order::Checkout.new(user: Current.user)
  end

  def create
    @checkout = Order::Checkout.new(user: Current.user, **order_params)

    if @checkout.create_order
      redirect_to @checkout.order, flash: { success: "Your order was successfully placed" }
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params
      .fetch(:order, {})
      .permit(
        :total_due_in_cents,
        :save_payment_method,
        :payment_method_id,
        shopping_cart_selection_ids: [],
        guest_orderer_attributes: %i[first_name last_name email phone],
        shipping_address_attributes: [:first_name, :last_name, { address_attributes: %i[address_1 address_2 city state zip_code] }]
      ).tap do |params|
      params[:shopping_cart_selection_ids] = params[:shopping_cart_selection_ids].map(&:to_i)
    end
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
