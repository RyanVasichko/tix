module User::Searches
  include StripsSpecialCharactersFromPhone
  extend ActiveSupport::Concern

  included do
    orderable_by :email

    scope :keyword_search, ->(keyword) {
      where(<<-SQL, keyword: "%#{keyword}%")
          CONCAT(first_name, ' ', last_name) ILIKE :keyword OR
          email ILIKE :keyword OR
          #{strip_special_characters_from_phone_sql("phone")} ILIKE :keyword
      SQL
    }

    scope :order_by_name, ->(direction = :asc) {
      order(Arel.sql("LOWER(CONCAT(first_name, ' ', last_name)) #{direction}"))
    }

    scope :order_by_phone, ->(direction = :asc) {
      order(Arel.sql("#{strip_special_characters_from_phone_sql("phone")} #{direction}"))
    }
  end
end
