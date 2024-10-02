class Order::SearchIndex < ApplicationRecord
  belongs_to :order
  self.primary_key = :order_id

  def self.populate_for(order)
    transaction do
      delete_by(order_id: order.id)

      create!(order_id: order.id,
              order_number: order.order_number,
              created_at: order.created_at.to_fs(:date),
              orderer_name: order.orderer.name,
              orderer_phone: order.orderer.phone.gsub("-", "").gsub("(", "").gsub(")", "").gsub(" ", ""),
              orderer_email: order.orderer.email,
              balance_paid: order.balance_paid.to_s.gsub(".", ""),
              artist_name: order.shows.map { |s| "#{s.artist.name} - #{s.show_date.to_fs(:date)}" }.uniq.join(", "),
              tickets_count: order.tickets_count)
    end
  end
end
