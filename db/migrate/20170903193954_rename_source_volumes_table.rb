class RenameSourceVolumesTable < ActiveRecord::Migration[5.1]
  def change
    change_table :volumes do |t|
      t.column :aquarium_url, :string
    end

    rename_column :volumes, :source, :aerostatica_url
  end
end
