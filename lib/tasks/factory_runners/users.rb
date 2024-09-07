module FactoryRunners
  class Users
    def run
      puts "- #{admins_count + 1} admins"

      bar = ProgressBar.new(admins_count, :bar, :counter, :percentage)
      FactoryBot.create(:admin, password: "Radiohead", password_confirmation: "Radiohead", email: "fake_admin@test.com")
      bar.increment!

      admins_count.times do
        FactoryBot.create(:admin)
        bar.increment!
      end

      bar = ProgressBar.new(customers_count, :bar, :counter, :percentage)

      puts "- #{customers_count} customers"
      customers_count.times do
        FactoryBot.create(:customer)
        bar.increment!
      end
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
