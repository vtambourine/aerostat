class AddLabelColumnToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :label, :string
    add_column :tracks, :error, :string
    add_column :tracks, :is_reviewed, :boolean, default: false
  end
end
