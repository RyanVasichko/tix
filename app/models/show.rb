class Show < ApplicationRecord
  include GoesOnSale, Agenda

  before_commit -> { orders.each(&:populate_search_index_later) }, if: -> { saved_change_to_show_date? || saved_change_to_artist_id? }

  validates :show_date, presence: true
  scope :upcoming, -> { where(show_date: Time.current..) }
  validates :skip_email_reminder, inclusion: { in: [true, false] }
  validates :type, presence: true

  belongs_to :artist
  delegate :name, to: :artist, prefix: true

  belongs_to :venue

  has_many :sections, class_name: "Show::Section", inverse_of: :show
  has_many :tickets, class_name: "Order::Ticket", inverse_of: :show
  has_many :orders, through: :tickets
  has_and_belongs_to_many :customer_questions
  has_many :upsales, class_name: "Show::Upsale", inverse_of: :show

  accepts_nested_attributes_for :sections, allow_destroy: true
  accepts_nested_attributes_for :upsales, reject_if: :all_blank

  def contains_deposit_section?
    sections.any?(&:deposit?)
  end
end
