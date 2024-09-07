module FactoryRunners
  class Orders
    def run
      puts "- #{customer_orders_count} customer orders"
      bar = ProgressBar.new(customer_orders_count, :bar, :counter, :percentage)
      customer_orders_count.times do
        FactoryBot.create \
          :customer_order,
          with_existing_shows: true,
          with_existing_user: true,
          with_existing_merch: true

        bar.increment!
      end

      puts "- #{guest_orders_count} guest orders"
      bar = ProgressBar.new(guest_orders_count, :bar, :counter, :percentage)
      guest_orders_count.times do
        FactoryBot.create(:guest_order, with_existing_shows: true, with_existing_merch: true)
        bar.increment!
      end
    end

    private

    def customer_orders_count
      ENV.fetch("CUSTOMER_ORDERS_COUNT", 10).to_i
    end

    def guest_orders_count
      ENV.fetch("GUEST_ORDERS_COUNT", 10).to_i
    end
  end
end
