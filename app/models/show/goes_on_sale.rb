module Show::GoesOnSale
  extend ActiveSupport::Concern

  included do
    validates :front_end_on_sale_at, presence: true
    validates :front_end_off_sale_at, presence: true
    validates :back_end_on_sale_at, presence: true
    validates :back_end_off_sale_at, presence: true

    scope :on_sale_front_end, -> { where(front_end_on_sale_at: Time.current..) }
    scope :on_sale_back_end, -> { where(back_end_on_sale_at: Time.current..) }

    after_initialize :set_default_on_sale_time_values, if: :new_record?
  end

  def set_default_on_sale_time_values
    self.back_end_on_sale_at ||= Time.current.change(hour: 22, min: 0, sec: 0)
    self.back_end_off_sale_at ||= Time.current.change(hour: 22, min: 0, sec: 0)
    self.front_end_on_sale_at ||= Time.current.change(hour: 22, min: 0, sec: 0)
    self.front_end_off_sale_at ||= Time.current.change(hour: 14, min: 0, sec: 0)
  end
end
