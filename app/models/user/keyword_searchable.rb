module User::KeywordSearchable
  extend ActiveSupport::Concern

  included do
    scope :keyword_search, ->(keyword) {
      where(<<-SQL, keyword: "%#{keyword}%")
        CONCAT(first_name, ' ', last_name) LIKE :keyword OR
        email LIKE :keyword OR
        REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', '') LIKE :keyword
      SQL
    }
  end
end
