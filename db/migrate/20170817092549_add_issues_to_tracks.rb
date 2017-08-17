class AddIssuesToTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :issues_tracks, id: false do |t|
      t.belongs_to :issue, index: true
      t.belongs_to :track, index: true
    end
  end
end
