class AddBoxIdToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :box_id, :integer
  end
end
