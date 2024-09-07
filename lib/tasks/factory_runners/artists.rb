module FactoryRunners
  class Artists
    def run
      puts "- #{artists_count} artists"
      bar = ProgressBar.new(artists_count, :bar, :counter, :percentage)
      artists_count.times do
        FactoryBot.create(:artist, image: ARTIST_IMAGE_BLOBS.sample)
        bar.increment!
      end
    end

    private

    ARTIST_IMAGE_BLOBS = [
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("test", "fixtures", "files", "radiohead.jpg")),
        filename: "radiohead.jpg",
        content_type: "image/jpeg"
      ).signed_id,
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("test", "fixtures", "files", "lcd_soundsystem.webp")),
        filename: "lcd_soundsystem.webp",
        content_type: "image/webp"
      ).signed_id
    ]

    def artists_count
      ENV.fetch("ARTISTS_COUNT", 20).to_i
    end
  end
end
