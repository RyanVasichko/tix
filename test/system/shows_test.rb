require "application_system_test_case"

class ShowsTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit shows_url
    assert_selector "h1", text: "Upcoming Shows"
  end
end
