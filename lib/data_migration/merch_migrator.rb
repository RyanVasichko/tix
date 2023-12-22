module DataMigration
  class MerchMigrator < BaseMigrator
    def migrate
      migrate_merch
      migrate_shipping_charges
    end

    private

    def migrate_merch
      puts "Migrating merch..."
      create_categories_from_og_categories

      process_in_threads(OG::Merch.all) { |og_merch| create_merch_from_og_merch(og_merch) }
      puts "Merch migration complete"
    end

    def migrate_shipping_charges
      puts "Migrating shipping charges..."
      OG::ShippingCharge.all.each do |og_shipping_charge|
        Merch::ShippingCharge.create!(id: og_shipping_charge.id,
                                      weight: og_shipping_charge.maximum_weight,
                                      price: og_shipping_charge.price,
                                      created_at: og_shipping_charge.created_at)
      end
      puts "Shipping charges migration complete"
    end

    def create_categories_from_og_categories
      OG::Category.all.each do |og_category|
        Merch::Category.create!(id: og_category.id,
                                name: og_category.name,
                                created_at: og_category.created_at)
      end
    end

    def create_merch_from_og_merch(og_merch)
      # merch_image = download_attachment(og_merch.image)
      # OG Schema:
      # t.boolean "featured"
      # t.integer "position"
      # t.decimal "weight", precision: 8, scale: 2
      # t.boolean "tax"
      # t.boolean "shipping"

      # New Schema:
      # t.string "options"
      # t.string "option_label"

      new_merch = Merch.new(id: og_merch.id,
                            name: og_merch.title,
                            description: og_merch.description,
                            price: og_merch.price,
                            active: og_merch.active,
                            option_label: og_merch.option_name,
                            options: og_merch.option_values,
                            created_at: og_merch.created_at,
                            updated_at: og_merch.updated_at,
                            category_ids: og_merch.category_ids)
      attach_image_to_merch(new_merch, og_merch)
      new_merch.save!
    end

    def attach_image_to_merch(new_merch, og_merch)
      og_merch_image = download_attachment(og_merch.image)
      new_merch.image.attach(io: og_merch_image,
                             filename: og_merch.image_file_name,
                             content_type: og_merch.image_content_type)
    end
  end
end
