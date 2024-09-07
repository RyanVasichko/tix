FactoryBot.define do
  factory :artist do
    name { ArtistNameGenerator.instance.unique_artist_name }
    bio { Faker::Lorem.paragraph }
    url { Faker::Internet.url }
    active { true }
    image do
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("test/fixtures/files/lcd_soundsystem.webp")),
        filename: "lcd_soundsystem.webp",
        content_type: "image/webp")
    end

    trait :with_show do
      after(:build) do |artist|
        artist.shows << FactoryBot.build(:reserved_seating_show, artist: artist)
      end
    end
  end
end
