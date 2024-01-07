module Show::SeatingChartable
  extend ActiveSupport::Concern

  included do
    attr_accessor :seating_chart_id
    has_one_attached :venue_layout
    validates :seating_chart_name, presence: true

    after_initialize :set_seating_chart_name, if: :seating_chart_id
    after_initialize :set_venue_layout, if: :seating_chart_id
  end

  private

  def set_seating_chart_name
    self.seating_chart_name = SeatingChart.find(seating_chart_id).name
  end

  def set_venue_layout
    self.venue_layout.attach(SeatingChart.includes(:venue_layout_blob).find(seating_chart_id).venue_layout.blob)
  end
end
