class Order::SearchIndex::PopulateJob < ApplicationJob
  def perform(order)
    order = Order.find(order) if order.is_a? Integer
    Order::SearchIndex.populate_for(order)
  end
end
