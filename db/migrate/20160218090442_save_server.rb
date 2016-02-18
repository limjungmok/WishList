class SaveServer < ActiveRecord::Migration
	def change
		change_column :products, :img, :text, :limit => nil, :default => nil
	end
end
