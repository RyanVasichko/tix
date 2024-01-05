module DataMigration
  class ReservedSeatingShowsMigrator < BaseMigrator
    def migrate
      puts "Migrating reserved seating shows..."
      ActiveRecord::Base.transaction do
        OG::ReservedSeatingShow.includes(sections: { section: [:ticket_type], tickets: :seat })
                               .in_batches(of: 400)
                               .each do |batch|
          Process.fork do
            batch.each do |show|
              create_show_from_og_show(show)
            end
          end
        end

        Process.waitall

        puts "Reserved seating shows migration complete"
      end
    end

    private

    def create_show_from_og_show(og_show)
      # OG Fields:
      # t.datetime "deactivated_at"
      # t.integer "deactivated_by_id"
      # t.integer "projected"
      Show::ReservedSeatingShow.create!(id: og_show.id,
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
                                        seating_chart_name: og_show.seating_chart.name,
                                        deposit_amount: og_show.deposit_amount || 0,
                                        skip_email_reminder: og_show.deactive || false,
                                        google_ad_id: og_show.googleads,
                                        announced_at: og_show.accounced_date,
                                        original_date: og_show.original_date,
                                        sections: build_sections_for_og_show(og_show),
                                        seating_chart_id: og_show.seating_chart_id)
    end

    def build_sections_for_og_show(show)
      show.sections.map do |show_section|
        if show_section.section.nil?
          puts "No show section for show #{show.artist.name} - #{show.date} (#{show.id}), section #{show_section.name} (#{show_section.id}). Skipping."
          next
        end
        Show::ReservedSeatingSection.new(id: show_section.id,
                                         name: show_section.section&.name || "Unknown",
                                         ticket_quantity: show_section.quantity,
                                         ticket_price: show_section.price,
                                         created_at: show_section.created_at,
                                         convenience_fee: show_section.section&.ticket_type&.convenience_fee,
                                         venue_commission: show_section.section&.ticket_type&.venue_commission,
                                         convenience_fee_type: show_section.section ? convenience_fee_type_for_ticket_type(show_section.section.ticket_type) : nil,
                                         payment_method: show_section.section&.ticket_type&.payment_method,
                                         seats: build_seats_for_og_show_section(show_section))
      end.compact
    end

    def build_seats_for_og_show_section(show_section)
      # TODO: Ticket holds
      show_section.tickets.map do |ticket|
        Show::Seat.new(seat_number: ticket.seat.seat_number,
                       table_number: ticket.seat.table_number,
                       created_at: ticket.created_at,
                       x: ticket.seat.x,
                       y: ticket.seat.y)
      end
    end
  end
end
