class DeleteColumnToLogs < ActiveRecord::Migration
  def change
    remove_column :logs, :logout_time
  end
end
