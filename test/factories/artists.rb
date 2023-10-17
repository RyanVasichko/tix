FactoryBot.define do
  factory :artist do
    name do
      begin
        Faker::Music.unique.band
      rescue Faker::UniqueGenerator::RetryLimitExceeded
        Faker::Music.band + SecureRandom.hex(4)
      end
    end

    bio { Faker::Lorem.paragraph }
    url { Faker::Internet.url }
    active { true }
  end
end