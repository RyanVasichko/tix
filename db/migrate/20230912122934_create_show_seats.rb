class CreateShowSeats < ActiveRecord::Migration[7.0]
  def change
    create_table :show_seats do |t|
      t.references :show_section, null: false, foreign_key: true
      t.integer :x
      t.integer :y
      t.integer :seat_number
      t.integer :table_number
      t.integer :reserved_by_id
      t.datetime :reserved_until

      t.timestamps
    end
  end
end
