# Giga seed:
# PROCESS_COUNT=8 ARTISTS_COUNT=125 UPCOMING_GENERAL_ADMISSION_SHOWS_COUNT=60 UPCOMING_RESERVED_SEATING_SHOWS_COUNT=60 PAST_GENERAL_ADMISSION_SHOWS_COUNT=1000 PAST_RESERVED_SEATING_SHOWS_COUNT=1000 CUSTOMERS_COUNT=500 CUSTOMER_ORDERS_COUNT=500 GUEST_ORDERS_COUNT=500 bin/rails db:factories:load

namespace :db do
  namespace :factories do
    task load: [:environment, "db:reset"] do
      require_relative "./factory_runners/artists"
      require_relative "./factory_runners/general_admission_shows"
      require_relative "./factory_runners/merch"
      require_relative "./factory_runners/orders"
      require_relative "./factory_runners/reserved_seating_shows"
      require_relative "./factory_runners/users"
      require_relative "./factory_runners/venues"

      Tickets::ReservedSeating.suppressing_turbo_broadcasts do
        ShoppingCart.suppressing_turbo_broadcasts do
          start = Time.current

          puts "Creating:"

          FactoryRunners::Artists.new.run
          FactoryRunners::Venues.new.run
          FactoryRunners::GeneralAdmissionShows.new.run
          FactoryRunners::ReservedSeatingShows.new.run

          Process.waitall

          FactoryRunners::Merch.new.run
          FactoryRunners::Users.new.run
          FactoryRunners::Orders.new.run

          puts "Factories loaded. Total time: #{Time.current - start}"
        end
      end
    end
  end
end
