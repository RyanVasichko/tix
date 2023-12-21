class CreateSeatingCharts < ActiveRecord::Migration[7.0]
  def change
    create_table :seating_charts do |t|
      t.string :name, null: false, unique: true
      t.boolean :active, null: false, default: true
      t.boolean :published, null: false, default: true

      t.timestamps
    end
  end
end
