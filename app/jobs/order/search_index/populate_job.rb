class Order::SearchIndex::PopulateJob < ApplicationJob
  def perform(order)
    Order::SearchIndex.populate_for(order)
  end
end
