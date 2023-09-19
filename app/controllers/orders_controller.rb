class OrdersController < ApplicationController
  def index
    @orders = Current.user.orders
  end

  def show
    @order = Current.user.orders.find(params[:id])
  end

  def new
    @order = Order::OrderForm.for_user(Current.user)

    if Current.user.shopping_cart.empty?
      redirect_to root_path,
                  flash: {
                    notice: "Your shopping cart is empty, add some items to your shopping cart to check out"
                  }
      return
    end
  end

  def edit
  end

  def create
    @order = Current.user.order_form_type.new(order_params)

    if @order.save
      redirect_to @order, flash: { success: "Your order was successfully placed" }
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params
      .require(:order)
      .permit(
        :order_total_in_cents,
        :payment_method_id,
        :save_payment_method,
        :new_payment_method,
        :email,
        :first_name,
        :last_name,
        :phone,
        { seat_ids: [] }
      )
      .merge(user: Current.user)
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
