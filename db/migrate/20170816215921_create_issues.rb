class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.integer :number
      t.string :title

      t.timestamps
    end
    add_index :issues, :number, unique: true
  end
end
