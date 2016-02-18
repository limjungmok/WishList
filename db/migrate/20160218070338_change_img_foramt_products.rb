class ChangeImgForamtProducts < ActiveRecord::Migration
  def change
    remove_column :products, :img
    add_column :products, :img, :text
  end
end
