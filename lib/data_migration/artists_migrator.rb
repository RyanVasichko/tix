require 'open-uri'

module DataMigration
  class ArtistsMigrator < BaseMigrator
    def migrate
      ActiveRecord::Base.transaction do
        puts "Migrating artists..."

        OG::Artist.in_batches(of: 250).each do |og_artists|
          process_in_threads(og_artists) do |og_artist|
            create_artist_from_og_artist(og_artist)
          end
        end

        puts "Artists migration complete"
      end
    end

    private

    def create_artist_from_og_artist(og_artist)
      # artist_image = download_attachment(og_artist.image)
      Artist.create!(id: og_artist.id,
                     name: og_artist.name,
                     bio: og_artist.bio,
                     url: og_artist.url,
                     created_at: og_artist.created_at,
                     image: artist_image_blobs.sample) # open(og_artist.image.expiring_url(600, :original)))
    end

    def artist_image_blobs
      @artist_image_blobs ||= [
        ActiveStorage::Blob.create_and_upload!(
          io: File.open(Rails.root.join("test", "fixtures", "files", "radiohead.jpg")),
          filename: "radiohead.jpg",
          content_type: "image/jpeg"
        ),
        ActiveStorage::Blob.create_and_upload!(
          io: File.open(Rails.root.join("test", "fixtures", "files", "lcd_soundsystem.webp")),
          filename: "lcd_soundsystem.webp",
          content_type: "image/webp"
        )
      ]
    end
  end
end
