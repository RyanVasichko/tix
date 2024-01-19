class CreateShowSeats < ActiveRecord::Migration[7.0]
  def change
    create_table :show_seats do |t|
      t.references :show_section, null: false, foreign_key: true
      t.integer :x, null: false
      t.integer :y, null: false
      t.integer :seat_number, null: false
      t.integer :table_number, null: true
      t.references :user_shopping_cart, null: true, foreign_key: true
      t.references :held_by_admin, null: true, foreign_key: { to_table: :users }
      t.datetime :reserved_until
      t.index %i[user_shopping_cart_id reserved_until]

      t.timestamps
    end
  end
end
