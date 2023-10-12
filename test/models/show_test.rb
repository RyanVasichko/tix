require "test_helper"

class ShowTest < ActiveSupport::TestCase
  test 'should sync start and end time with show date' do
    show = shows(:lcd_soundsystem)

    show.show_date = Date.new(2026, 9, 19)
    show.start_time = Time.new(2000, 1, 1, 15, 0, 0)
    show.end_time = Time.new(2000, 1, 1, 17, 0, 0)
    show.save

    assert_equal DateTime.new(2026, 9, 19, 15, 0, 0), show.start_time
    assert_equal DateTime.new(2026, 9, 19, 17, 0, 0), show.end_time
  end

end
