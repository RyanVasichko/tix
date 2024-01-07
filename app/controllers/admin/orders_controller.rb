class Admin::OrdersController < Admin::AdminController
  include Searchable

  def index
    orders = Order.includes(:orderer)
    orders = orders.keyword_search(search_keyword) if search_keyword.present?
    @pagy, @orders = pagy(orders)
  end
end
