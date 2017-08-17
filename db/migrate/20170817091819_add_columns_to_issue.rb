class AddColumnsToIssue < ActiveRecord::Migration[5.1]
  def change
    change_table :issues do |t|
      t.text :text
      t.integer :duration
      t.text :source
    end
  end
end
