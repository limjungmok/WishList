class ChangeDefaultForProducts < ActiveRecord::Migration
  def change
  	change_column :products, :name, :string, :default => ""
  	change_column :products, :price, :integer, :default => 0
  	change_column :products, :img, :string, :default => ""
  	change_column :products, :url, :string, :default => ""
  end
end
