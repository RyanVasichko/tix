module SeatingChart::Copyable
  extend ActiveSupport::Concern

  included do
    attr_accessor :venue_layout_signed_id
    before_validation -> { venue_layout.attach(venue_layout_signed_id) }, if: -> { venue_layout_signed_id.present? && new_record? }
  end

  class_methods do
    def build_copy_from(other)
      seating_chart = other.dup
      seating_chart.name = "#{other.name} (Copy)"
      seating_chart.venue = other.venue
      seating_chart.venue_layout.attach other.venue_layout.blob

      seating_chart.sections = other.sections.map do |section|
        section.dup.tap do |cloned_section|
          cloned_section.id = SecureRandom.random_number(1_000_000) + 100_000_000_000
          cloned_section.seats = section.seats.map(&:dup)
        end
      end

      seating_chart
    end
  end
end
