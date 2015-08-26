class RenameDiFmTracksTable < ActiveRecord::Migration
  def change
    rename_table :di_fm_tracks, :tracks
  end
end
