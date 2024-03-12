require "test_helper"

class ShowTest < ActiveSupport::TestCase
  setup do
    @show = FactoryBot.build(:reserved_seating_show)
  end

  test "should be valid" do
    assert @show.valid?
  end

  test "should save" do
    assert @show.save
  end

  test "should have a show date" do
    @show.show_date = nil
    assert_not @show.valid?
  end

  test "should have a type" do
    @show.type = nil
    assert_not @show.valid?
  end

  test "should have a front end on sale at" do
    @show.front_end_on_sale_at = nil
    assert_not @show.valid?
  end

  test "should have a front end off sale at" do
    @show.front_end_off_sale_at = nil
    assert_not @show.valid?
  end

  test "should have a back end on sale at" do
    @show.back_end_on_sale_at = nil
    assert_not @show.valid?
  end

  test "should have a back end off sale at" do
    @show.back_end_off_sale_at = nil
    assert_not @show.valid?
  end

  test "should have an on sale front end scope" do
    on_sale_front_end_reserved_seating_show = FactoryBot.create(:reserved_seating_show,
                                                                front_end_on_sale_at: Time.current - 1.day,
                                                                front_end_off_sale_at: Time.current + 1.day)
    on_sale_front_end_general_admission_show = FactoryBot.create(:general_admission_show,
                                                                  front_end_on_sale_at: Time.current - 2.days,
                                                                  front_end_off_sale_at: Time.current + 2.days)

    off_sale_front_end_reserved_seating_show = FactoryBot.create(:reserved_seating_show,
                                                                 front_end_on_sale_at: Time.current + 1.day,
                                                                 front_end_off_sale_at: Time.current + 2.days)
    off_sale_front_end_general_admission_show = FactoryBot.create(:general_admission_show,
                                                                    front_end_on_sale_at: Time.current + 2.days,
                                                                    front_end_off_sale_at: Time.current + 3.days)

    assert_includes Show.on_sale_front_end, on_sale_front_end_reserved_seating_show
    assert_includes Show.on_sale_front_end, on_sale_front_end_general_admission_show

    assert_not_includes Show.on_sale_front_end, off_sale_front_end_reserved_seating_show
    assert_not_includes Show.on_sale_front_end, off_sale_front_end_general_admission_show
  end

  test "should have an on sale back end scope" do
    on_sale_back_end_reserved_seating_show = FactoryBot.create(:reserved_seating_show,
                                                              back_end_on_sale_at: Time.current - 1.day,
                                                              back_end_off_sale_at: Time.current + 1.day)
    on_sale_back_end_general_admission_show = FactoryBot.create(:general_admission_show,
                                                                back_end_on_sale_at: Time.current - 2.days,
                                                                back_end_off_sale_at: Time.current + 2.days)

    off_sale_back_end_reserved_seating_show = FactoryBot.create(:reserved_seating_show,
                                                               back_end_on_sale_at: Time.current + 1.day,
                                                               back_end_off_sale_at: Time.current + 2.days)
    off_sale_back_end_general_admission_show = FactoryBot.create(:general_admission_show,
                                                                back_end_on_sale_at: Time.current + 2.days,
                                                                back_end_off_sale_at: Time.current + 3.days)

    assert_includes Show.on_sale_back_end, on_sale_back_end_reserved_seating_show
    assert_includes Show.on_sale_back_end, on_sale_back_end_general_admission_show

    assert_not_includes Show.on_sale_back_end, off_sale_back_end_reserved_seating_show
    assert_not_includes Show.on_sale_back_end, off_sale_back_end_general_admission_show
  end

  test "should sync start and end time with show date" do
    show = FactoryBot.build(:reserved_seating_show)

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

  test "should rebuild the order index when the artist changes" do
    skip "I can't get order_search_indices to create in test environment"

    show = FactoryBot.create(:reserved_seating_show)
    order = FactoryBot.create(:customer_order, with_existing_shows: true)

    show.artist = FactoryBot.create(:artist)
    show.save

    perform_enqueued_jobs

    assert Order::SearchIndex.find_by(order_id: order.id)
  end
end
