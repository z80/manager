class AddImageToWarehouse < ActiveRecord::Migration
  def change
  	add_attachment :warehouses, :image
  end
end
