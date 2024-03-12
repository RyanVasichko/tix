class Admin::OrdersController < Admin::AdminController
  include SearchParams

  sortable_by :order_number, :created_at, :orderer_name, :orderer_phone, :orderer_email, :tickets_count, :order_total
  self.default_sort_field = :created_at

  def index
    @pagy, @orders = pagy(Order.search(search_params))
  end

  def show
    @order = Order.find(params[:id])
  end
end
