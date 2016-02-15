class DeleteColumn2ToProducts < ActiveRecord::Migration
  def change
    remove_column :products, :avatar_file_name
    remove_column :products, :avatar_content_type
    remove_column :products, :avatar_file_size
    remove_column :products, :avatar_updated_at
  end
end
