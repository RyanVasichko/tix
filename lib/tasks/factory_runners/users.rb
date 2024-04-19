module FactoryRunners
  class Users
    def run
      FactoryBot.create_list(:customer, customers_count)
      puts "- #{customers_count} customers"

      FactoryBot.create(:admin, password: "Radiohead", password_confirmation: "Radiohead", email: "fake_admin@test.com")
      FactoryBot.create_list(:admin, admins_count)
      puts "- #{admins_count + 1} admins"
    end

    private

    def customers_count
      ENV.fetch("CUSTOMERS_COUNT", 10).to_i
    end

    def admins_count
      ENV.fetch("ADMINS_COUNT", 1).to_i
    end
  end
end
