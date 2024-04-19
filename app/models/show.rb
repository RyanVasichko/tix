class Show < ApplicationRecord
  include GoesOnSale, Agenda, Searchable

  validates :show_date, presence: true
  scope :upcoming, -> { where(show_date: Time.current..) }
  validates :type, presence: true

  belongs_to :artist, counter_cache: :shows_count
  delegate :name, to: :artist, prefix: true
  scope :includes_artist, -> { includes(artist: [image_attachment: :blob]) }

  belongs_to :venue
  delegate :name, to: :venue, prefix: true

  has_many :sections, class_name: "Show::Section", inverse_of: :show
  has_many :tickets, through: :sections
  has_many :ticket_purchases, class_name: "Order::Purchase", through: :tickets, source: :purchase
  has_many :orders, through: :ticket_purchases

  has_and_belongs_to_many :customer_questions
  has_many :upsales, class_name: "Show::Upsale", inverse_of: :show

  orderable_by :show_date, artist: %i[name], venue: %i[name]

  scope :keyword_search, ->(keyword) {
    joins(:artist, :venue).where(<<~SQL, keyword: "%#{keyword}%", date: Chronic.parse(keyword)&.to_date)
      artists.name ILIKE :keyword OR
      venues.name ILIKE :keyword OR 
      shows.show_date = :date
    SQL
  }

  accepts_nested_attributes_for :sections, allow_destroy: true
  accepts_nested_attributes_for :upsales, reject_if: :all_blank

  def contains_deposit_section?
    sections.any?(&:deposit_payment_method?)
  end
end
