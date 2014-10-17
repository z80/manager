class RemoveUnused < ActiveRecord::Migration
  def change
  	remove_column :products, :belongs_id
  	remove_column :products, :prod_subtype_id
  end
end
