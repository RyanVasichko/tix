FactoryBot.define do
  factory :artist do
    name { Faker::Music.unique.band }
    bio { Faker::Lorem.paragraph }
    url { Faker::Internet.url }
    active { true }

    trait :with_show do
      after(:build) do |artist|
        artist.shows << FactoryBot.build(:show, artist: artist)
      end
    end

    transient do
      image_blob do
        ActiveStorage::Blob.create_and_upload!(
          io: File.open(Rails.root.join("test/fixtures/files/lcd_soundsystem.webp")),
          filename: "lcd_soundsystem.webp",
          content_type: "image/webp")
      end
    end

    after(:build) do |artist, evaluator|
      artist.image.attach(evaluator.image_blob)
    end
  end
end