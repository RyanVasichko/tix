require "test_helper"

class ShowTest < ActiveSupport::TestCase
  test 'should sync start and end time with show date' do
    show = FactoryBot.build(:show)

    next_year = Time.current.year + 1

    show.show_date = Date.new(next_year, 9, 19)
    show.show_starts_at = Time.zone.local(2000, 1, 1, 15, 0, 0)
    show.doors_open_at = Time.zone.local(2000, 1, 1, 14, 0, 0)
    show.dinner_starts_at = Time.zone.local(2000, 1, 1, 14, 0, 0)
    show.dinner_ends_at = Time.zone.local(2000, 1, 1, 15, 0, 0)

    show.save

    assert_equal Time.zone.local(next_year, 9, 19, 15, 0, 0), show.show_starts_at
    assert_equal Time.zone.local(next_year, 9, 19, 14, 0, 0), show.doors_open_at
    assert_equal Time.zone.local(next_year, 9, 19, 14, 0, 0), show.dinner_starts_at
    assert_equal Time.zone.local(next_year, 9, 19, 15, 0, 0), show.dinner_ends_at
  end
end
