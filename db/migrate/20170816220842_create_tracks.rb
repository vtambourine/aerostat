class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :artist
      t.string :title
      t.time :duration

      t.timestamps
    end
  end
end
