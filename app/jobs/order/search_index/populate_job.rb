class Order::SearchIndex::PopulateJob < ApplicationJob
  def perform(order_id)
    Order::SearchIndex.populate_for(Order.find(order_id))
  end
end
