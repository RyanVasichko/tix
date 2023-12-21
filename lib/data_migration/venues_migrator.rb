module DataMigration
  class VenuesMigrator
    def migrate
      puts "Migrating venues..."

      ActiveRecord::Base.transaction do
        OG::Venue.includes(:address).in_batches(of: 1000).each_record do |venue|
          address = Address.build(id: venue.address_id,
                                  address_1: venue.address.street_1,
                                  address_2: venue.address.street_2,
                                  city: venue.address.city,
                                  state: venue.address.state,
                                  zip_code: venue.address.zip_code,
                                  created_at: venue.address.created_at)
          Venue.create!(id: venue.id,
                        name: venue.name,
                        created_at: venue.created_at,
                        phone: venue.phone,
                        image: nil, # open(venue.image.expiring_url(600, :original)))
                        sales_tax: venue.sales_tax,
                        address: address)
        end
      end

      puts "Venues migration complete"
    end
  end
end
