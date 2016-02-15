class DeleteColumnToProducts < ActiveRecord::Migration
  def change
    remove_column :products, :avater_file_name
    remove_column :products, :avater_content_type
    remove_column :products, :avater_file_size
    remove_column :products, :avater_updated_at
  end
end