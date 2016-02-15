class AddColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :user_login_id, :string
  end
end
