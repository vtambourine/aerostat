class MakeUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :artists, :name_hash, unique: true
  end
end
