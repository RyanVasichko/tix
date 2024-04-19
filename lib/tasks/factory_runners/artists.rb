module FactoryRunners
  class Artists
    def run
      (1..artists_count).map { FactoryBot.create(:artist, image_blob: ARTIST_IMAGE_BLOBS.sample) }
      puts "- #{artists_count} artists"
    end

    private

    ARTIST_IMAGE_BLOBS = [
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
    ].freeze

    def artists_count
      ENV.fetch("ARTISTS_COUNT", 20).to_i
    end
  end
end
