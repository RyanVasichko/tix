class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email, unique: true
      t.string :password_digest
      t.boolean :guest, default: false
      t.boolean :admin, default: false

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE users ADD CONSTRAINT check_guest_fields#{' '}
    CHECK ((guest = false AND first_name IS NOT NULL AND last_name IS NOT NULL AND email IS NOT NULL) OR guest = true);
    SQL
  end
end
