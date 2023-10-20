class CreateShowSeats < ActiveRecord::Migration[7.0]
  def change
    create_table :show_seats do |t|
      t.references :show_section, null: false, foreign_key: true
      t.integer :x, null: false
      t.integer :y, null: false
      t.integer :seat_number, null: false
      t.integer :table_number, null: true
      t.references :user_shopping_cart, null: true, foreign_key: true
      t.datetime :reserved_until

      t.timestamps
    end
  end
end
