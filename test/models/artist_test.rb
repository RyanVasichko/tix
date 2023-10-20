require "test_helper"

class ArtistTest < ActiveSupport::TestCase
  test "Deactivatable" do
    artist = FactoryBot.create(:artist, name: "Radiohead")
    artist.deactivate!
    assert_equal false, artist.active
    assert_equal "Radiohead (Deactivated)", artist.reload.name

    new_radiohead_artist = Artist.create!(name: "Radiohead")
    new_radiohead_artist.deactivate!
    assert_equal "Radiohead (Deactivated 2)", new_radiohead_artist.reload.name

    new_radiohead_artist_2 = Artist.create!(name: "Radiohead")
    new_radiohead_artist_2.deactivate!
    assert_equal "Radiohead (Deactivated 3)", new_radiohead_artist_2.reload.name

    new_radiohead_artist.activate!
    assert_equal "Radiohead", new_radiohead_artist.reload.name

    new_radiohead_artist_2.activate!
    assert_equal "Radiohead (Deactivated 3)", new_radiohead_artist_2.reload.name
  end
end
