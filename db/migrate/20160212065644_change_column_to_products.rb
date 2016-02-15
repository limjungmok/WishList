class ChangeColumnToProducts < ActiveRecord::Migration
  def change
    remove_column :products, :origin_url
    remove_column :products, :user_login_id
    add_column :products, :user_info, :string
  end
end
