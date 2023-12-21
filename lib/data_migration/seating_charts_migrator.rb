module DataMigration
  class SeatingChartsMigrator < BaseMigrator
    def migrate
      ActiveRecord::Base.transaction do
        puts "Migrating seating charts..."

        og_seating_charts = OG::SeatingChart.includes(sections: :seats).all
        process_in_threads(og_seating_charts) do |og_seating_chart|
          create_seating_chart_from_og_seating_chart(og_seating_chart)
        end

        puts "Seating charts migration complete"
      end
    end

    private

    def create_seating_chart_from_og_seating_chart(og_seating_chart)
      build_seating_chart_from_og_seating_chart(og_seating_chart).save!
    end

    def build_seating_chart_from_og_seating_chart(og_seating_chart)
      new_seating_chart = SeatingChart.new(id: og_seating_chart.id,
                                           name: og_seating_chart.name,
                                           venue_id: og_seating_chart.venue_id,
                                           created_at: og_seating_chart.created_at,
                                           # TODO: Figure out how published and active works
                                           # TODO: Add deactivated_by to Deactivateable
                                           published: og_seating_chart.published,
                                           # deactivated_by_id: seating_chart.deactivated_by_id
                                           # deactivated_at: seating_chart.deactivated_at,
                                           active: !og_seating_chart.deactivated_at.present?,
                                           sections: build_sections_from_og_seating_chart(og_seating_chart))

      new_seating_chart.send(:add_suffix_to_name) unless new_seating_chart.active?

      attach_og_chart_image_to_new_seating_chart(new_seating_chart, og_seating_chart)
      new_seating_chart
    end

    def build_sections_from_og_seating_chart(og_seating_chart)
      og_seating_chart.sections.map do |og_section|
        SeatingChart::Section.new(id: og_section.id,
                                  name: og_section.name,
                                  ticket_type_id: og_section.ticket_type_id,
                                  created_at: og_section.created_at,
                                  seats: build_seats_from_og_section(og_section))
      end
    end

    def build_seats_from_og_section(og_section)
      og_section.seats.map do |og_seat|
        SeatingChart::Seat.new(id: og_seat.id,
                               seat_number: og_seat.seat_number,
                               table_number: og_seat.table_number,
                               x: og_seat.x,
                               y: og_seat.y,
                               created_at: og_seat.created_at)
      end
    end

    def attach_og_chart_image_to_new_seating_chart(new_seating_chart, og_seating_chart)
      return unless og_seating_chart.chart_image.exists?

      file = download_attachment(og_seating_chart.chart_image)
      new_seating_chart.venue_layout.attach(io: file,
                                            filename: og_seating_chart.chart_image_file_name,
                                            content_type: og_seating_chart.chart_image_content_type)
    end
  end
end
