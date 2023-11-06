class Show < ApplicationRecord
  include GoesOnSale, Agenda
  attr_accessor :seating_chart_id

  has_one_attached :venue_layout

  validates :seating_chart_name, presence: true

  validates :show_date, presence: true
  scope :upcoming, -> { where(show_date: Time.current..) }

  belongs_to :artist
  delegate :name, to: :artist, prefix: true

  belongs_to :venue

  has_many :sections, class_name: "Show::Section", inverse_of: :show
  has_many :seats, through: :sections
  has_many :tickets, class_name: "Order::Ticket", inverse_of: :show
  has_and_belongs_to_many :customer_questions
  has_many :upsales, class_name: "Show::Upsale", inverse_of: :show

  accepts_nested_attributes_for :sections, allow_destroy: true
  accepts_nested_attributes_for :upsales, reject_if: :all_blank

  after_initialize :set_seating_chart_name, if: :seating_chart_id
  after_initialize :set_venue_layout, if: :seating_chart_id

  private

  def set_seating_chart_name
    self.seating_chart_name = SeatingChart.find(seating_chart_id).name
  end

  def set_venue_layout
    self.venue_layout.attach(SeatingChart.includes(:venue_layout_blob).find(seating_chart_id).venue_layout.blob)
  end
end
