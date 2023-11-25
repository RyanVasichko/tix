class CreateOrderTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :order_tickets do |t|
      t.references :order, null: false, foreign_key: true
      t.references :show_seat, null: false, foreign_key: true
      t.references :show, null: false, foreign_key: true
      t.decimal :convenience_fees, null: false, default: 0, precision: 8, scale: 2
      t.decimal :venue_commission, null: false, default: 0, precision: 8, scale: 2
      t.decimal :ticket_price, null: false, default: 0, precision: 8, scale: 2
      t.decimal :total_price, null: false, default: 0, precision: 8, scale: 2

      t.timestamps
    end
  end
end
