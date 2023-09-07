require "application_system_test_case"

class Admin::ArtistsTest < ApplicationSystemTestCase
  setup do
    @artist = artists(:radiohead)
  end

  test "visiting the index" do
    visit admin_artists_url
    assert_selector "h1", text: "Artists"
  end

  test "should create artist" do
    assert_difference "Artist.count" do
      visit admin_artists_url
      click_on "New Artist"
  
      fill_in "Name", with: "New artist name"
      fill_in "Url", with: "New artist URL"
      fill_in "Bio", with: "New artist bio"
      attach_file('artist_image', Rails.root.join('test/fixtures/files/radiohead.jpg'))
  
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

    find("##{dom_id(@artist, :admin)}_dropdown").click
    click_on "Deactivate"
  end
end
