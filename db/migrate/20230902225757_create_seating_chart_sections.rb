class CreateSeatingChartSections < ActiveRecord::Migration[7.0]
  def change
    create_table :seating_chart_sections do |t|
      t.string :name, null: false
      t.index [:name, :seating_chart_id], unique: true
      t.references :seating_chart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
