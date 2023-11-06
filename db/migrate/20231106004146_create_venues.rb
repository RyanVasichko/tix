class CreateVenues < ActiveRecord::Migration[7.1]
  def change
    create_table :venues do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_reference :seating_charts, :venue, foreign_key: true
    add_reference :shows, :venue, foreign_key: true
  end
end
