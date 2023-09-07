class CreateShows < ActiveRecord::Migration[7.0]
  def change
    create_table :shows do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :seating_chart, null: false, foreign_key: true
      t.datetime :show_date
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
