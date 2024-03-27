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

    has_one :search_index, class_name: "Order::SearchIndex", dependent: :destroy
    before_commit :populate_search_index_later

    ORDER_SEARCH_INDICES_JOIN = "INNER JOIN order_search_indices ON order_search_indices.order_id = orders.id".freeze
    scope :keyword_search, ->(keyword) {
      joins("#{ORDER_SEARCH_INDICES_JOIN} AND order_search_indices MATCH '\"#{keyword}\"'")
    }
  end

  def populate_search_index_later
    Order::SearchIndex::PopulateJob.perform_later(self)
  end

  def populate_search_index
    Order::SearchIndex.populate_for(self)
  end
end
