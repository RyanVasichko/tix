module Order::Searches
  extend ActiveSupport::Concern

  included do
    orderable_by :created_at, :balance_paid, :order_number
    scope :order_by_orderer_name, ->(direction = :asc) {
      joins(ORDER_SEARCH_INDICES_JOIN).order(sanitize_sql("order_search_indices.orderer_name COLLATE NOCASE #{direction}"))
    }

    scope :order_by_orderer_phone, ->(direction = :asc) {
      joins(ORDER_SEARCH_INDICES_JOIN).order(sanitize_sql("order_search_indices.orderer_phone COLLATE NOCASE #{direction}"))
    }

    scope :order_by_orderer_email, ->(direction = :asc) {
      joins(ORDER_SEARCH_INDICES_JOIN).order(sanitize_sql("order_search_indices.orderer_email COLLATE NOCASE #{direction}"))
    }

    scope :order_by_tickets_count, ->(direction = :asc) {
      joins(ORDER_SEARCH_INDICES_JOIN).order(sanitize_sql("order_search_indices.tickets_count #{direction}"))
    }
  end
end