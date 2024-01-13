module Show::KeywordSearchable
  extend ActiveSupport::Concern

  included do
    scope :keyword_search, -> (keyword) {
      joins(:artist, :venue).where(<<~SQL, keyword: "%#{keyword}%")
        artists.name LIKE :keyword OR
        venues.name LIKE :keyword OR
        strftime('%m/%d/%Y', shows.show_date) LIKE :keyword
      SQL
    }
  end
end
