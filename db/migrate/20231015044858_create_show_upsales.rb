class CreateShowUpsales < ActiveRecord::Migration[7.1]
  def change
    create_table :show_upsales do |t|
      t.string :name, null: false
      t.index [:name, :show_idx], unique: true
      t.text :description
      t.references :show, null: false, foreign_key: true
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :quantity, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
