class AddOriginUrlToProducts < ActiveRecord::Migration
  def change
    add_column :products, :origin_url, :text
  end
end
