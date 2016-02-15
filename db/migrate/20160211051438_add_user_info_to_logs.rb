class AddUserInfoToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :user_info, :string
  end
end
