class Orders::ShoppingCartTicketsController < ApplicationController
  before_action :set_ticket

  def destroy
    @ticket.destroy!

    redirect_back_or_to new_order_path
  end

  def update
    @ticket.update(quantity: params[:quantity])

    redirect_back_or_to new_order_path
  end

  private

  def set_ticket
    @ticket = Current.user.shopping_cart.tickets.find(params[:id])
  end
end
