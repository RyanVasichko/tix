class CreateVenues < ActiveRecord::Migration[7.1]
  def change
    create_table :venues do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: true
      t.string :phone
      t.references :address, foreign_key: true
      t.decimal :sales_tax, precision: 4, scale: 2, default: "0.0", null: false

      t.timestamps
    end

    add_reference :seating_charts, :venue, foreign_key: true
    add_reference :shows, :venue, foreign_key: true
  end
end
