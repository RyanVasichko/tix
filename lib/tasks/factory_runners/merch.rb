module FactoryRunners
  class Merch
    def run
      merch_categories = FactoryBot.create_list(:merch_category, merch_categories_count)
      puts "- #{merch_categories_count} merch categories"

      merch_count.times do
        FactoryBot.create(:merch, categories: merch_categories, image_blob: MERCH_IMAGE_BLOB)
      end
      puts "- #{merch_count} merch"

      merch_shipping_rates_count.times do |index|
        ::Merch::ShippingRate.create!(weight: index * 5, price: index + 1)
      end
      puts "- #{merch_shipping_rates_count} merch shipping rates"
    end

    private

    MERCH_IMAGE_BLOB = ActiveStorage::Blob.create_and_upload! \
      io: File.open(Rails.root.join("test/fixtures/files/bbq_sauce.png")),
      filename: "bbq_sauce.png",
      content_type: "image/png"

    def merch_count
      merch_count = ENV.fetch("MERCH_COUNT", 5).to_i
    end

    def merch_categories_count
      ENV.fetch("MERCH_CATEGORIES_COUNT", 5).to_i
    end

    def merch_shipping_rates_count
      ENV.fetch("MERCH_SHIPPING_RATES_COUNT", 3).to_i
    end
  end
end
