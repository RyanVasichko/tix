class Admin::OrdersController < Admin::AdminController
  include SearchParams

  sortable_by :order_number, :created_at, :orderer_name, :orderer_phone, :orderer_email, :tickets_count, :balance_paid
  self.default_sort_field = :created_at

  def index
    @pagy, @orders = pagy(Order.includes_show.includes(:orderer).search(search_params))
  end

  def show
    @order = Order.find(params[:id])
  end
end
