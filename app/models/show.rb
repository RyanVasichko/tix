class Show < ApplicationRecord
  include GoesOnSale, Agenda, Searchable

  before_commit :rebuild_index_for_show_orders, if: -> { saved_change_to_show_date? || saved_change_to_artist_id? }

  validates :show_date, presence: true
  scope :upcoming, -> { where(show_date: Time.current..) }
  validates :type, presence: true

  belongs_to :artist
  delegate :name, to: :artist, prefix: true

  belongs_to :venue
  delegate :name, to: :venue, prefix: true

  has_many :sections, class_name: "Show::Section", inverse_of: :show
  has_many :tickets, through: :sections
  has_many :ticket_purchases, class_name: "Order::Purchase", through: :tickets, source: :purchase
  has_many :orders, through: :ticket_purchases

  has_and_belongs_to_many :customer_questions
  has_many :upsales, class_name: "Show::Upsale", inverse_of: :show

  orderable_by :show_date, :doors_open_at, :dinner_starts_at, :dinner_ends_at,
               artist: %i[name],
               venue: %i[name]

  scope :keyword_search, ->(keyword) {
    joins(:artist, :venue).where(<<~SQL, keyword: "%#{keyword}%")
      artists.name LIKE :keyword OR
      venues.name LIKE :keyword OR
      strftime('%m/%d/%Y', shows.show_date) LIKE :keyword
    SQL
  }

  accepts_nested_attributes_for :sections, allow_destroy: true
  accepts_nested_attributes_for :upsales, reject_if: :all_blank

  def contains_deposit_section?
    sections.any?(&:deposit_payment_method?)
  end

  private

  def rebuild_index_for_show_orders
    jobs = orders.pluck(:id).map { |order_id| Order::SearchIndex::PopulateJob.new(order_id) }
    ActiveJob.perform_all_later(jobs)
  end
end
