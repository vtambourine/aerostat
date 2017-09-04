class AddNameToArtists < ActiveRecord::Migration[5.1]
  def change
    change_table :artists do |t|
      t.column :name, :string
      t.column :raw_name, :string
      t.column :raw_name_hash, :string
      t.column :is_reviewed, :boolean
    end

    change_table :volumes do |t|
      t.column :raw_title, :string
      t.column :raw_title_hash, :string
    end

    change_table :tracks do |t|
      t.belongs_to :artist, index: true
      t.column :raw_title, :string
      t.column :raw_title_hash, :string
    end
  end
end
