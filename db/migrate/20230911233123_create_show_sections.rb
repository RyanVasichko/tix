class CreateShowSections < ActiveRecord::Migration[7.0]
  def change
    create_table :show_sections do |t|
      t.references :show, null: false, foreign_key: true
      t.decimal :ticket_price, precision: 10, scale: 2, null: false
      t.references :seating_chart_section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
