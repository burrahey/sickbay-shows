class DropVenueArtists < ActiveRecord::Migration[5.0]
  def change
    drop_table :venue_artists
  end
end
