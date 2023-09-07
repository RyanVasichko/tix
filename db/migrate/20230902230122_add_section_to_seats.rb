class AddSectionToSeats < ActiveRecord::Migration[7.0]
  def change
    add_reference :seating_chart_seats, :seating_chart_section, null: false, foreign_key: true
    remove_column :seating_chart_seats, :seating_chart_id
  end
end
