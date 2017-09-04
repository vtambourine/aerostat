class RenameColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :artists, :raw_name_hash, :name_hash
    rename_column :tracks, :raw_title_hash, :title_hash
    rename_column :volumes, :raw_title_hash, :title_hash

  end
end
