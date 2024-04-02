require "application_system_test_case"

class Admin::ArtistsTest < ApplicationSystemTestCase
  setup do
    sign_in FactoryBot.create(:admin)
    @artist = FactoryBot.create(:artist, :with_show)
  end

  test "visiting the index" do
    visit admin_artists_url
    assert_selector "h1", text: "Artists"
    assert_text @artist.name
  end

  test "should create artist" do
    assert_difference "Artist.count" do
      visit admin_artists_url
      find("#new_artist").click

      fill_in "Name", with: "New artist name"
      fill_in "Url", with: "New artist URL"
      fill_in "Bio", with: "New artist bio"
      attach_file("artist_image", Rails.root.join("test/fixtures/files/radiohead.jpg"))

      click_on "Create Artist"

      assert_text "Artist was successfully created"

      created_artist = Artist.last
      assert "New artist name", created_artist.name
      assert "New artist URL", created_artist.url
      assert "New artist bio", created_artist.bio
      assert created_artist.image.attached?
    end
  end

  test "should update Artist" do
    visit edit_admin_artist_url(@artist)

    fill_in "Name", with: "Updated artist name"
    fill_in "Url", with: "Updated artist URL"
    fill_in "Bio", with: "Updated artist bio"

    click_on "Update Artist"

    assert_text "Artist was successfully updated"

    @artist.reload

    assert "Updated artist name", @artist.name
    assert "Updated artist URL", @artist.url
    assert "Updated artist bio", @artist.bio
  end

  test "should deactivate an Artist if they have any shows" do
    visit admin_artists_url

    within "tr", text: @artist.name do
      click_on "Deactivate"
    end
  end
end
