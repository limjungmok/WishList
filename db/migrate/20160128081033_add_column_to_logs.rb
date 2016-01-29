class AddColumnToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :logout_time, :datetime
  end
end
