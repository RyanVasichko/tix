class CreateUserShoppingCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :user_shopping_carts do |t|
      t.timestamps
    end
  end
end
