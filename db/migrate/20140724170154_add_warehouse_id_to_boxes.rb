class AddWarehouseIdToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :warehouse_id, :integer
  end
end
