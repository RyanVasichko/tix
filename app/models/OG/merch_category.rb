module OG
  class MerchCategory < Record
    belongs_to :merch, class_name: 'OG::Merch', foreign_key: :merch_id
    belongs_to :category
  end
end
