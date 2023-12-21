namespace :db do
  namespace :og_data do
    desc "Import data from old database"
    task load: [:environment, "db:drop", "db:prepare"] do
      start_time = Time.zone.now
      puts "Started loading OG data at #{start_time}"

      DataMigration::UsersMigrator.new.migrate
      DataMigration::ArtistsMigrator.new.migrate
      DataMigration::VenuesMigrator.new.migrate
      DataMigration::TicketTypesMigrator.new.migrate
      DataMigration::SeatingChartsMigrator.new.migrate
      DataMigration::ReservedSeatingShowsMigrator.new.migrate
      DataMigration::GeneralAdmissionShowsMigrator.new.migrate
      DataMigration::MerchMigrator.new.migrate

      DataMigration::SqliteSequencesFixer.new.fix_sequences

      time_elapsed = Time.zone.now - start_time
      puts "Finished loading OG data at #{Time.zone.now}, total load time: #{time_elapsed} seconds"
    end
  end
end
