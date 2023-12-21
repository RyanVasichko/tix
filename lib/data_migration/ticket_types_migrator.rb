module DataMigration
  class TicketTypesMigrator < BaseMigrator
    def migrate
      puts "Migrating ticket types..."

      ActiveRecord::Base.transaction do
        OG::TicketType.in_batches(of: 1000).each_record do |ticket_type|
          TicketType.create!(id: ticket_type.id,
                             name: ticket_type.name,
                             venue_id: ticket_type.venue_id,
                             created_at: ticket_type.created_at,
                             active: ticket_type.active,
                             dinner_included: ticket_type.dinner_included,
                             convenience_fee: ticket_type.convenience_fee,
                             convenience_fee_type: convenience_fee_type_for_ticket_type(ticket_type),
                             default_price: ticket_type.default_price,
                             venue_commission: ticket_type.venue_commission,
                             payment_method: ticket_type.payment_method)
        end
      end

      puts "Ticket types migration complete"
    end
  end
end
