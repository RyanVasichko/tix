class SeatingChart < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one_attached :venue_layout
  has_many :sections, dependent: :destroy, class_name: 'SeatingChart::Section', inverse_of: :seating_chart
  has_many :seats, through: :sections, source: :seats

  accepts_nested_attributes_for :sections, allow_destroy: true

  validates :name, presence: true
  validates :venue_layout, presence: true
  validates :sections, presence: true

  attribute :active, :boolean, default: true

  scope :active, -> { where(active: true) }

  def dup
    cloned_seating_chart = super

    cloned_seating_chart.name = "#{name} (Copy)"

    sections.each do |section|
      cloned_section = section.dup
      cloned_seating_chart.sections << cloned_section

      section.seats.each do |seat|
        cloned_seat = seat.dup
        cloned_section.seats << cloned_seat
      end
    end

    cloned_seating_chart
  end

  def dup_venue_layout_from(seating_chart_id) 
    seating_chart = SeatingChart.find(seating_chart_id)
    return unless seating_chart.venue_layout.attached?

    original_blob = seating_chart.venue_layout.blob

    cloned_blob_attrs = original_blob.attributes.except('id', 'created_at', 'updated_at')
    venue_layout.attach(io: StringIO.new(original_blob.download),
                                             filename: cloned_blob_attrs['filename'],
                                             content_type: cloned_blob_attrs['content_type'],
                                             metadata: cloned_blob_attrs['metadata'])
  end
end
