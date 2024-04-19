module StripsSpecialCharactersFromPhone
  extend ActiveSupport::Concern

  class_methods do
    def strip_special_characters_from_phone_sql(property)
      "REPLACE(REPLACE(REPLACE(REPLACE(#{property}, '-', ''), '(', ''), ')', ''), ' ', '')"
    end
  end
end
