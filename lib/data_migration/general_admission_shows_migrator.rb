module DataMigration
  class GeneralAdmissionShowsMigrator < BaseMigrator
    def migrate
      puts "Migrating general admission shows..."

      ActiveRecord::Base.transaction do
        OG::GeneralAdmissionShow.in_batches(of: 400).each do |batch|
          Process.fork do
            batch.each do |show|
              create_show_from_og_show(show)
            end
          end
        end

        Process.waitall

        puts "General admission shows migration complete"
      end
    end

    private

    def create_show_from_og_show(og_show)
      Show::GeneralAdmissionShow.create!(id: og_show.id,
                                         artist_id: og_show.artist_id,
                                         show_date: og_show.date,
                                         doors_open_at: og_show.doors_open_at,
                                         show_starts_at: og_show.show_starts_at,
                                         dinner_starts_at: og_show.dinner_starts_at,
                                         dinner_ends_at: og_show.dinner_ends_at,
                                         created_at: og_show.created_at,
                                         venue_id: og_show.venue_id,
                                         front_end_on_sale_at: og_show.front_end_on_sale_at,
                                         front_end_off_sale_at: og_show.front_end_off_sale_at,
                                         back_end_on_sale_at: og_show.back_end_on_sale_at,
                                         back_end_off_sale_at: og_show.back_end_off_sale_at,
                                         additional_text: og_show.additional_text,
                                         deposit_amount: og_show.deposit_amount || 0,
                                         skip_email_reminder: og_show.deactive || false,
                                         google_ad_id: og_show.googleads,
                                         announced_at: og_show.accounced_date,
                                         original_date: og_show.original_date,
                                         sections: build_sections_for_og_show(og_show))
    end

    def build_sections_for_og_show(og_show)
      og_show.sections.map do |show_section|
        Show::GeneralAdmissionSection.new(id: show_section.id,
                                          name: show_section.name,
                                          ticket_quantity: show_section.quantity,
                                          ticket_price: show_section.price,
                                          convenience_fee: show_section.GAfee || 0)
      end
    end
  end
end
