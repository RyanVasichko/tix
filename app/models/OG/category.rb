module OG
  class Category < Record
    has_many :merch_categories, class_name: 'OG::MerchCategory', foreign_key: :category_id
    has_many :merch, through: :merch_categories
  end
end
