class Shows::ReservedSeating < Show
  has_many :sections, class_name: "Show::Sections::ReservedSeating", inverse_of: :show
  has_many :seats, class_name: "Show::Seat", through: :sections
  delegate :seat_number, :table_number, to: :seats

  has_one_attached :venue_layout
  validates :seating_chart_name, presence: true

  attr_accessor :seating_chart_id
  after_initialize :copy_fields_from_seating_chart, if: -> { seating_chart_id.present? && new_record? }

  private

  def copy_fields_from_seating_chart
    self.seating_chart_name = SeatingChart.find(seating_chart_id).name
    self.venue_layout.attach(SeatingChart.find(seating_chart_id).venue_layout.blob)
  end
end
