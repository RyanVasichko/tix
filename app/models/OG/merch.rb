module OG
  class Merch < Record
    has_many :merch_categories, class_name: 'OG::MerchCategory', foreign_key: :merch_id
    has_many :categories, through: :merch_categories

    has_attached_file :image, {
      path: "/merch/:attachment/:id_partition/:style/:filename"
    }
  end
end
