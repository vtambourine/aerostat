class AddReviewedToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :is_reviewed, :boolean, default: false
  end
end
