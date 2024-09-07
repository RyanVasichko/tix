# Giga seed:
# DISABLE_DATABASE_ENVIRONMENT_CHECK=1 \
#   FACTORIES_FORKING=0 \
#   HOST=dummy \
#   RAILS_ENV=production \
#   ARTISTS_COUNT=3000 \
#   UPCOMING_GENERAL_ADMISSION_SHOWS_COUNT=30 \
#   UPCOMING_RESERVED_SEATING_SHOWS_COUNT=60 \
#   PAST_GENERAL_ADMISSION_SHOWS_COUNT=50000 \
#   PAST_RESERVED_SEATING_SHOWS_COUNT=100000 \
#   CUSTOMERS_COUNT=50000 \
#   CUSTOMER_ORDERS_COUNT=500000 \
#   GUEST_ORDERS_COUNT=1000000 \
#   bin/rails db:factories:load

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

      Rails.logger.level = :warn

      Tickets::ReservedSeating.suppressing_turbo_broadcasts do
        ShoppingCart.suppressing_turbo_broadcasts do
          start = Time.current

          puts "Creating:"

          FactoryRunners::Users.new.run
          FactoryRunners::Artists.new.run
          FactoryRunners::Venues.new.run
          FactoryRunners::GeneralAdmissionShows.new.run
          FactoryRunners::ReservedSeatingShows.new.run

          FactoryRunners::Merch.new.run
          FactoryRunners::Orders.new.run

          puts "Factories loaded. Total time: #{Time.current - start}"
        end
      end
    end
  end
end
