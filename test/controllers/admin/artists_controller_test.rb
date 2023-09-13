require "test_helper"

class Admin::ArtistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    skip "for now"
    @artist = artists(:radiohead)
  end

  test "should get index" do
    get admin_artists_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_artist_url
    assert_response :success
  end

  test "should create an artist" do
    assert_difference("Artist.count") do
      params = { 
        artist: 
        { 
          name: "New artist name", 
          bio: "New artist bio", 
          url: "New artist url",
          image: fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'lcd_soundsystem.webp'), 'image/webp')
        } 
      }
      post admin_artists_url, params: params
    end

    assert_redirected_to admin_artists_url
  end

  test "should get edit" do
    get edit_admin_artist_url(@artist)
    assert_response :success
  end

  test "should update artists" do
    params = { 
      artist: 
      { 
        name: "Updated artist name", 
        bio: "Updated artist bio", 
        url: "Updated artist url",
        image: fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'lcd_soundsystem.webp'), 'image/webp')
      } 
    }

    patch admin_artist_url(@artist), params: params
    assert_redirected_to admin_artists_url
  end

  test "should deactivate an artist that has shows" do
    delete admin_artist_url(@artist)

    @artist.reload

    refute @artist.active?

    assert_redirected_to admin_artists_url
  end

  test "should destroy an artist without any shows" do
    @artist.shows.destroy_all

    assert_difference("Artist.count", -1) do
      delete admin_artist_url(@artist)
    end

    assert_redirected_to admin_artists_url
  end
end
