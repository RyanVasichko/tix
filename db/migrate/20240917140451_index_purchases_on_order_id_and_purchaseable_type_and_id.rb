class IndexPurchasesOnOrderIdAndPurchaseableTypeAndId < ActiveRecord::Migration[7.2]
  def change
    add_index :order_purchases, [:order_id, :purchaseable_type, :purchaseable_id]
  end
end
