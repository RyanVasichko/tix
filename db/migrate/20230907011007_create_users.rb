class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email, unique: true
      t.string :password_digest
      t.string :type, null: false
      t.string :stripe_customer_id
      t.references :user_shopping_cart, null: false, foreign_key: true
      t.string :shopper_uuid, null: false
      # t.virtual :full_name, type: :string, as: "CASE WHEN type = 'User::Guest' THEN NULL ELSE COALESCE(first_name, ' ', last_name) END", stored: true
      t.check_constraint <<-SQL, name: 'check_guest_fields'
        (
           type != 'User::Guest' 
           AND first_name IS NOT NULL 
           AND last_name IS NOT NULL 
           AND email IS NOT NULL 
           AND password_digest IS NOT NULL
        ) 
        OR type = 'User::Guest'
      SQL

      t.timestamps
    end
  end
end
