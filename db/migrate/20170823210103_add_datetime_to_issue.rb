class AddDatetimeToIssue < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :date, :date
  end
end
