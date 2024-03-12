module Order::KeywordSearchable
  extend ActiveSupport::Concern

  included do
    has_one :search_index, class_name: "Order::SearchIndex", dependent: :destroy
    before_commit :populate_search_index_later

    ORDER_SEARCH_INDICES_JOIN = "INNER JOIN order_search_indices ON order_search_indices.order_id = orders.id".freeze
    scope :keyword_search, ->(keyword) {
      sanitized_keyword = ActiveRecord::Base.sanitize_sql_like(keyword.gsub(".", ""))
      sanitized_keyword = "'\"#{sanitized_keyword}\"'" # Surround with quotes to match whole words
      joins("#{ORDER_SEARCH_INDICES_JOIN} MATCH #{sanitized_keyword}")
    }
  end

  def populate_search_index_later
    Order::SearchIndex::PopulateJob.perform_later(self)
  end

  def populate_search_index
    Order::SearchIndex.populate_for(self)
  end
end
