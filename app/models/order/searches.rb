module Order::Searches
  extend ActiveSupport::Concern
  include StripsSpecialCharactersFromPhone

  included do
    orderable_by :created_at, :balance_paid, :order_number

    scope :order_by_orderer_name, ->(direction = :asc) {
      joins(ORDERER_JOIN).order(Arel.sql(<<-ORDER_SQL))
        CASE
          WHEN order_guest_orderers.id IS NOT NULL THEN LOWER(CONCAT(order_guest_orderers.first_name, ' ', order_guest_orderers.last_name))
          WHEN users.id IS NOT NULL THEN LOWER(CONCAT(users.first_name, ' ', users.last_name))
        END  #{direction}
      ORDER_SQL
    }

    scope :order_by_orderer_phone, ->(direction = :asc) {
      joins(ORDERER_JOIN).order(Arel.sql(<<-ORDER_SQL))
        CASE
          WHEN order_guest_orderers.id IS NOT NULL THEN LOWER(order_guest_orderers.phone)
          WHEN users.id IS NOT NULL THEN LOWER(users.phone)
        END  #{direction}
      ORDER_SQL
    }

    scope :order_by_orderer_email, ->(direction = :asc) {
      joins(ORDERER_JOIN).order(Arel.sql(<<-ORDER_SQL))
        CASE
          WHEN order_guest_orderers.id IS NOT NULL THEN LOWER(order_guest_orderers.email)
          WHEN users.id IS NOT NULL THEN LOWER(users.email)
        END  #{direction}
      ORDER_SQL
    }

    scope :order_by_tickets_count, ->(direction = :asc) {
      joins(:tickets).order(Arel.sql("SUM(order_purchases.quantity) #{direction}")).group(:id)
    }

    scope :keyword_search, ->(keyword) {
      time_zone = ActiveSupport::TimeZone::MAPPING[Time.zone.name]
      keyword_as_date = Chronic.parse(keyword)&.to_date
      joins(ORDERER_JOIN)
        .where(<<-SQL, keyword: "%#{keyword}%", start_date: keyword_as_date&.beginning_of_day, end_date: keyword_as_date&.end_of_day)
          orders.order_number ILIKE :keyword OR
          orders.created_at BETWEEN :start_date AND :end_date OR
          CONCAT(order_guest_orderers.first_name, ' ', order_guest_orderers.last_name) ILIKE :keyword OR
          CONCAT(users.first_name, ' ', users.last_name) ILIKE :keyword OR
          #{strip_special_characters_from_phone_sql("order_guest_orderers.phone")} ILIKE :keyword OR
          #{strip_special_characters_from_phone_sql("users.phone")} ILIKE :keyword OR
          order_guest_orderers.email ILIKE :keyword OR
          users.email ILIKE :keyword
        SQL
    }

    private

    ORDERER_JOIN = <<-SQL.freeze
        LEFT OUTER JOIN order_guest_orderers ON 
          orders.orderer_id = order_guest_orderers.id AND
          orders.orderer_type = 'Order::GuestOrderer'
        LEFT OUTER JOIN users ON
          orders.orderer_id = users.id AND 
          orders.orderer_type = 'User'
    SQL
  end
end
