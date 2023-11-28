require "application_integration_test_case"

class Admin::ArtistsControllerTest < ApplicationIntegrationTestCase
  setup do
    @artist = FactoryBot.create(:artist)
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
    artist_with_shows = FactoryBot.create(:artist, :with_show)
    delete admin_artist_url(artist_with_shows)

    artist_with_shows.reload

    refute artist_with_shows.active?

    assert_redirected_to admin_artists_url
  end

  test "should destroy an artist without any shows" do
    artist = Artist.create!(name: "Test Artist", bio: "Test Bio", url: "Test URL")
    
    assert_difference("Artist.count", -1) do
      delete admin_artist_url(artist)
    end

    assert_redirected_to admin_artists_url
  end
end