class CreateTicketTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :ticket_types do |t|
      t.references :venue, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :convenience_fee, precision: 8, scale: 2
      t.string :convenience_fee_type, null: false
      t.decimal :default_price, null: false, precision: 8, scale: 2
      t.decimal :venue_commission, null: false, precision: 8, scale: 2
      t.boolean :dinner_included, null: false, default: false
      t.boolean :active, null: false, default: true
      t.string :payment_method, null: false

      t.timestamps
    end

    add_reference :seating_chart_sections, :ticket_type, foreign_key: true, null: false
  end
end
