class CreateUserShoppingCartMerch < ActiveRecord::Migration[7.0]
  def change
    create_table :user_shopping_cart_merch do |t|
      t.references :merch, null: false, foreign_key: true
      t.references :user_shopping_cart, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.string :option

      t.timestamps
    end
  end
end