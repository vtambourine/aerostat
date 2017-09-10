class RenameVolumesToEpisodes < ActiveRecord::Migration[5.1]
  def change
    remove_index :volumes, :number
    rename_table :volumes, :episodes
    add_index :episodes, :number, unique: true

    remove_index :tracks_volumes, :volume_id
    rename_table :tracks_volumes, :episodes_tracks
    rename_column :episodes_tracks, :volume_id, :episode_id
    add_index :episodes_tracks, :episode_id
  end
end
