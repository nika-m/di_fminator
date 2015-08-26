class CreateDiFmTracks < ActiveRecord::Migration
  def change
    create_table :di_fm_tracks do |t|
      t.string :artist
      t.string :song
      t.string :track
      t.string :channel

      t.timestamps
    end
  end
end
