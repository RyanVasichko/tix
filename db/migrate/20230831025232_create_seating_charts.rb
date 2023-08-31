class CreateSeatingCharts < ActiveRecord::Migration[7.0]
  def change
    create_table :seating_charts do |t|
      t.string :name

      t.timestamps
    end
  end
end
