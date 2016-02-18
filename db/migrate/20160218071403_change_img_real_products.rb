class ChangeImgRealProducts < ActiveRecord::Migration
  def change
	change_column :products, :img, :text, :limit => nil

  end
end
