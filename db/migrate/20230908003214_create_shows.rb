class CreateShows < ActiveRecord::Migration[7.0]
  def change
    create_table :shows do |t|
      t.references :artist, null: false, foreign_key: true
      t.string :seating_chart_name, null: false
      t.datetime :show_date, null: false
      t.datetime :doors_open_at, null: false
      t.datetime :show_starts_at, null: false
      t.datetime :dinner_starts_at, null: false
      t.datetime :dinner_ends_at, null: false
      t.datetime :front_end_on_sale_at, null: false
      t.datetime :front_end_off_sale_at, null: false
      t.datetime :back_end_on_sale_at, null: false
      t.datetime :back_end_off_sale_at, null: false
      t.text :additional_text

      t.timestamps
    end
  end
end
