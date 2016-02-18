class ChangeImgProducts < ActiveRecord::Migration
	def change
    remove_column :products, :img
    add_column :products, :img, :string
  end
end
