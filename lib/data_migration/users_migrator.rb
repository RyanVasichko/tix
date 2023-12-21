module DataMigration
  class UsersMigrator < BaseMigrator
    def migrate
      ActiveRecord::Base.transaction do
        migrate_admins
        migrate_customers
      end
    end

    private

    def migrate_admins
      puts "Migrating admins..."

      OG::Admin.in_batches(of: 1000).each do |admins|
        process_in_threads(admins) do |admin|
          User::Admin.create!(create_params_for_user(admin))
        end
      end

      puts "Admins migration complete"
    end

    def migrate_customers
      puts "Migrating customers..."

      OG::Customer.in_batches(of: 1000).each do |customers|
        process_in_threads(customers) do |customer|
          User::Customer.create!(create_params_for_user(customer))
        end
      end

      puts "Customers migration complete"
    end

    def create_params_for_user(user)
      {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        phone: user.phone,
        password_digest: "$2a$10$ISlx0MgRTD9LIzE12AMjVearhmeu/Xze59T4httH3X3YQdU9ULBHa", # user.envrypted_password,
        created_at: user.created_at,
        stripe_customer_id: nil # user.stripe_token
        # TODO: marketing emails
      }
    end
  end
end
