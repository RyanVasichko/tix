class ArtistNameGenerator
  include Singleton

  def artist_name
    generated_name = band_name || hip_hop_artist_name || first_name_last_name
    while Artist.exists?(name: generated_name)
      puts "Name collission detected. Regenerating..."
      generated_name = band_name || hip_hop_artist_name || first_name_last_name
    end

    generated_name
  end

  private

  def band_name
    Faker::Music.unique.band
  rescue Faker::UniqueGenerator::RetryLimitExceeded
  end

  def hip_hop_artist_name
    Faker::Music::Hiphop.unique.artist
  rescue Faker::UniqueGenerator::RetryLimitExceeded
  end

  def first_name_last_name
    name = generate_first_and_last_name
    name = generate_first_and_last_name while Artist.exists?(name: name)

    name
  end

  def generate_first_and_last_name
    "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  end
end
