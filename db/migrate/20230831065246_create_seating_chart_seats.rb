class CreateSeatingChartSeats < ActiveRecord::Migration[7.0]
  def change
    create_table :seating_chart_seats do |t|
      t.integer :x, null: false
      t.integer :y, null: false
      t.string :seat_number, null: false
      t.string :table_number, null: false
      t.references :seating_chart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
