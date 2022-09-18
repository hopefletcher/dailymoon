class ChangeDateToDateTime < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :start_time
    remove_column :events, :end_time

    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
  end
end
