class CreateOrderTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :order_tickets do |t|
      t.references :order, null: false, foreign_key: true
      t.references :show_seat, null: false, foreign_key: true
      t.references :show, null: false, foreign_key: true
      t.decimal :price

      t.timestamps
    end
  end
end
