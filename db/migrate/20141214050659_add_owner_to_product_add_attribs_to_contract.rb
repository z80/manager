class AddOwnerToProductAddAttribsToContract < ActiveRecord::Migration
  def change
    add_column :products,  :owner_id, :integer
    add_column :contracts, :owner_id, :integer
    add_column :contracts, :box_id,   :integer
  end
end
