class Orders::ShoppingCartMerchController < ApplicationController
  before_action :set_shopping_cart_merch, only: %i[update destroy]

  def destroy
    if @shopping_cart_merch.destroy
      redirect_back fallback_location: new_order_url, notice: "Shopping cart updated.", status: :see_other
    else
      redirect_back fallback_location: new_order_url, error: "We encountered an error processing your request, please try again", status: :unprocessable_entity
    end
  end

  def update
    if @shopping_cart_merch.update(shopping_cart_merch_params)
      redirect_back fallback_location: new_order_url, notice: "Shopping cart updated.", status: :see_other
    else
      redirect_back :fallback_location, new_order_url, error: "We encountered an error processing your request, please try again", status: :unprocessable_entity
    end
  end

  private

  def set_shopping_cart_merch
    @shopping_cart_merch = Current.user.shopping_cart.merch.find(params[:id])
  end

  def shopping_cart_merch_params
    params.fetch(:shopping_cart_merch, {}).permit(:quantity)
  end
end