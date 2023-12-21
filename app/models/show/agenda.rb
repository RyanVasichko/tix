module Show::Agenda
  extend ActiveSupport::Concern

  included do
    validates :show_starts_at, presence: true
    validates :doors_open_at, presence: true
    validates :dinner_starts_at, presence: true
    validates :dinner_ends_at, presence: true

    before_save :normalize_times_with_show_date
    before_create -> { self.original_date ||= show_date }

    after_initialize :set_default_show_time_values, if: :new_record?
  end

  private

  def normalize_times_with_show_date
    return unless show_date.present?

    normalizer = ->(date) { date.change(year: show_date.year, month: show_date.month, day: show_date.day) if date.present? }
    normalize = ->(property) { send("#{property}=", normalizer.call(send(property))) }
    [:show_starts_at, :doors_open_at, :dinner_starts_at, :dinner_ends_at].each { |property| normalize.call(property) }
  end

  def set_default_show_time_values
    self.show_starts_at ||= Time.current.change(hour: 20, min: 30, sec: 0)
    self.doors_open_at ||= Time.current.change(hour: 18, min: 30, sec: 0)
    self.dinner_starts_at ||= Time.current.change(hour: 18, min: 30, sec: 0)
    self.dinner_ends_at ||= Time.current.change(hour: 19, min: 30, sec: 0)
  end
end
