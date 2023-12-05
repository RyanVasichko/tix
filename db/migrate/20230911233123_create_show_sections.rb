class CreateShowSections < ActiveRecord::Migration[7.0]
  def change
    create_table :show_sections do |t|
      t.references :show, null: false, foreign_key: true
      t.decimal :ticket_price, precision: 10, scale: 2, null: false
      t.integer :convenience_fee_type, null: false
      t.integer :payment_method, null: false
      t.decimal :convenience_fee, precision: 10, scale: 2, null: false
      t.decimal :venue_commission, precision: 10, scale: 2, null: false, default: 0
      t.integer :ticket_quantity
      t.string :name, null: false
      t.string :type, null: false

      t.timestamps
    end
  end
end
