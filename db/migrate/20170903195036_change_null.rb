class ChangeNull < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:artists, :is_reviewed, {from: nil, to: false})
  end
end
