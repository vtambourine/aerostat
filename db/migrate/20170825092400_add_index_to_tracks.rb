class AddIndexToTracks < ActiveRecord::Migration[5.1]
  def change
    add_index :tracks, [:artist, :title]
  end
end
