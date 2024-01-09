class Order::SearchIndex < ApplicationRecord
  belongs_to :order

  def self.populate_for(order)
    transaction do
      delete_by(order_id: order.id)

      create!(order_id: order.id,
              order_number: order.order_number,
              created_at: order.created_at.to_fs("mdy"),
              orderer_name: order.orderer.full_name,
              orderer_phone: order.orderer.phone.gsub("-", "").gsub("(", "").gsub(")", "").gsub(" ", ""),
              orderer_email: order.orderer.email,
              order_total: order.order_total.to_s.gsub(".", ""),
              artist_name: order.shows.map { |s| "#{s.artist.name} - #{s.show_date.to_fs(:mdy)}" }.uniq.join(", "))
    end
  end
end
