class Show < ApplicationRecord
  include GoesOnSale, Agenda

  belongs_to :artist
  delegate :name, to: :artist, prefix: true

  belongs_to :seating_chart
  has_many :sections, class_name: "Show::Section", inverse_of: :show
  has_many :seats, through: :sections
  has_many :tickets, class_name: "Order::Ticket", inverse_of: :show
  has_and_belongs_to_many :customer_questions
  has_many :upsales, class_name: "Show::Upsale", inverse_of: :show

  validates :show_date, presence: true
  scope :upcoming, -> { where(show_date: Time.current..) }

  accepts_nested_attributes_for :sections, allow_destroy: true
  accepts_nested_attributes_for :upsales, reject_if: :all_blank

  def build_seats
    sections.each(&:build_seats)
  end
end
