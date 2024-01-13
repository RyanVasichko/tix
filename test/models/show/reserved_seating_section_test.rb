require "test_helper"

class Show::ReservedSeatingSectionTest < ActiveSupport::TestCase
  test "calculates flat rate convenience fees" do
    section = Show::ReservedSeatingSection.new(convenience_fee_type: "flat_rate", convenience_fee: 5.0)
    assert_equal 5.0, section.ticket_convenience_fees
  end

  test "calculates convenience fees as a percentage" do
    section = Show::ReservedSeatingSection.new(convenience_fee_type: "percentage", convenience_fee: 1.25, ticket_price: 90.0)
    assert_equal 1.13, section.ticket_convenience_fees
  end
end