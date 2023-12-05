class CreateUserShoppingCartTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :user_shopping_cart_tickets do |t|
      t.references :show_section, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.references :user_shopping_cart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
