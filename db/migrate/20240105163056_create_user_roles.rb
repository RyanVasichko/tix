class CreateUserRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :user_roles do |t|
      t.string :name, null: false
      t.boolean :hold_seats, default: false, null: false
      t.boolean :release_seats, default: false, null: false
      t.boolean :manage_customers, default: false, null: false
      t.boolean :manage_admins, default: false, null: false

      t.timestamps
    end

    add_reference :users, :user_role, foreign_key: true

    add_check_constraint :users, "type != 'User::Admin' OR user_role_id IS NOT NULL", name: 'check_admin_role'
  end
end
