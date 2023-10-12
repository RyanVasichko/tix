class CreateMerchCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :merch_categories do |t|
      t.string :name, unique: true

      t.timestamps
    end

    create_join_table :merch, :merch_categories do |t|
      t.index :merch_id
      t.index :merch_category_id
    end
  end
end
