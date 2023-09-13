class Show < ApplicationRecord
  belongs_to :artist
  belongs_to :seating_chart
  has_many :sections, class_name: "Show::Section", inverse_of: :show
  has_many :seats, through: :sections

  validates :show_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  scope :upcoming, -> { where("show_date > ?", Time.current) }

  accepts_nested_attributes_for :sections, allow_destroy: true

  before_save :sync_start_and_end_time_with_show_date

  private

  def sync_start_and_end_time_with_show_date
    if show_date.present?
      if start_time.present?
        self.start_time =
          DateTime.new(
            show_date.year,
            show_date.month,
            show_date.day,
            start_time.hour,
            start_time.min,
            start_time.sec
          )
      end

      if end_time.present?
        self.end_time =
          DateTime.new(
            show_date.year,
            show_date.month,
            show_date.day,
            end_time.hour,
            end_time.min,
            end_time.sec
          )
      end
    end
  end
end
