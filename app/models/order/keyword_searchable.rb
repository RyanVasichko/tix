module Order::KeywordSearchable
  extend ActiveSupport::Concern

  included do
    scope :keyword_search, ->(keyword) {
      quoted_keyword = ActiveRecord::Base.connection.quote("%#{keyword}%")

      joins("LEFT OUTER JOIN order_guest_orderers ON order_guest_orderers.id = orders.orderer_id AND orders.orderer_type = 'Order::GuestOrderer'")
        .joins("LEFT OUTER JOIN users ON users.id = orders.orderer_id AND orders.orderer_type = 'User'")
        .left_outer_joins(shows: :artist)
        .where(<<-SQL, keyword: "%#{keyword}%")
          orders.order_number LIKE :keyword OR
          strftime('%m/%d/%Y', orders.created_at) LIKE :keyword OR
          CONCAT(users.first_name, ' ', users.last_name) LIKE :keyword OR
          REPLACE(REPLACE(REPLACE(REPLACE(users.phone, '-', ''), '(', ''), ')', ''), ' ', '') LIKE :keyword OR
          CONCAT(order_guest_orderers.first_name, ' ', order_guest_orderers.last_name) LIKE :keyword OR
          REPLACE(REPLACE(REPLACE(REPLACE(order_guest_orderers.phone, '-', ''), '(', ''), ')', ''), ' ', '') LIKE :keyword OR
          users.email LIKE :keyword OR
          order_guest_orderers.email LIKE :keyword OR
          orders.order_total LIKE :keyword OR
          artists.name LIKE :keyword
        SQL
    }
  end
end
