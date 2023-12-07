# test/models/show_test.rb
require "test_helper"

class SearchableTest < ActiveSupport::TestCase
  setup do
    Show.class_eval do
      searchable_by :venue_id
      searchable_by :artist_name, ->(artist_name) { joins(:artist).where(artists: { name: artist_name }) }
      searchable_by :show_date, date_range: true
    end

    @venue_1 = FactoryBot.create(:venue)
    @show_1 = FactoryBot.create(:reserved_seating_show,
                                artist: FactoryBot.create(:artist, name: "Radiohead"),
                                venue: @venue_1,
                                seating_chart_name: "Front Row",
                                show_date: "2021-01-10")

    @venue_2 = FactoryBot.create(:venue)
    @show_2 = FactoryBot.create(:general_admission_show,
                                artist: FactoryBot.create(:artist, name: "Led Zeppelin"),
                                venue: @venue_2,
                                show_date: "2021-01-20")
  end

  test "search by named property" do
    assert_includes Show.search(venue_id: @venue_1.id), @show_1
    refute_includes Show.search(venue_id: @venue_2.id), @show_1
  end

  test "search by artist_name using lambda" do
    assert_includes Show.search(artist_name: "Radiohead"), @show_1
    refute_includes Show.search(artist_name: "Radiohead"), @show_2
  end

  test "search by date range" do
    assert_includes Show.search(show_date: { start: "2021-01-05", end: "2021-01-15" }), @show_1
    refute_includes Show.search(show_date: { start: "2021-01-05", end: "2021-01-15" }), @show_2
  end
end
