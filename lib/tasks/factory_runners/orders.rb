module FactoryRunners
  class Orders
    def run
      FactoryBot.create_list(:customer_order, customer_orders_count, with_existing_shows: true, with_existing_user: true, with_existing_merch: true)
      puts "- #{customer_orders_count} customer orders"

      FactoryBot.create_list(:guest_order, guest_orders_count, with_existing_shows: true, with_existing_merch: true)
      puts "- #{guest_orders_count} guest orders"
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
