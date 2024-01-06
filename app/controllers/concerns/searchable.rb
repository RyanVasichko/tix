module Searchable
  extend ActiveSupport::Concern

  private

  def search_keyword
    params.dig(:search, :keyword)
  end

  def wildcard_search_keyword
    "%#{search_keyword}%"
  end
end
