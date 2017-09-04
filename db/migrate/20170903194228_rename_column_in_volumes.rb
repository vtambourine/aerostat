class RenameColumnInVolumes < ActiveRecord::Migration[5.1]
  def change
    rename_column :volumes, :date, :published_at
  end
end
