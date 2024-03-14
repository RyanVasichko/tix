class Shows::ReservedSeating < Show
  has_many :sections, class_name: "Show::Sections::ReservedSeating", inverse_of: :show
  has_many :seats, through: :sections
  has_many :tickets, class_name: "Order::Tickets::ReservedSeating", inverse_of: :show

  attr_accessor :seating_chart_id
  has_one_attached :venue_layout
  validates :seating_chart_name, presence: true

  after_initialize :set_seating_chart_name, if: :seating_chart_id
  after_initialize :set_venue_layout, if: :seating_chart_id

  private

  def set_seating_chart_name
    self.seating_chart_name = SeatingChart.find(seating_chart_id).name
  end

  def set_venue_layout
    self.venue_layout.attach(SeatingChart.find(seating_chart_id).venue_layout.blob)
  end
end