class User::ShoppingCartMerch < ApplicationRecord
  self.table_name = :user_shopping_cart_merch

  delegate :name, to: :merch, prefix: true
  
  belongs_to :merch, class_name: :Merch
  belongs_to :user
end
