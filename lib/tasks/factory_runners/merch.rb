module FactoryRunners
  class Merch
    def run
      puts "- #{merch_categories_count} merch categories"
      bar = ProgressBar.new(merch_categories_count, :bar, :counter, :percentage)
      merch_categories = (1..merch_categories_count).map do
        category = FactoryBot.create(:merch_category)
        bar.increment!
        category
      end

      puts "- #{merch_count} merch"
      bar = ProgressBar.new(merch_count, :bar, :counter, :percentage)
      merch_count.times do
        FactoryBot.create(:merch, categories: merch_categories, image_blob: MERCH_IMAGE_BLOB)
        bar.increment!
      end

      puts "- #{merch_shipping_rates_count} merch shipping rates"
      bar = ProgressBar.new(merch_shipping_rates_count, :bar, :counter, :percentage)
      merch_shipping_rates_count.times do |index|
        ::Merch::ShippingRate.create!(weight: index * 5, price: index + 1)
        bar.increment!
      end
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
