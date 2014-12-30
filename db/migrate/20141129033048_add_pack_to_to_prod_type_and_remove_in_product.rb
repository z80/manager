class AddPackToToProdTypeAndRemoveInProduct < ActiveRecord::Migration
  def change
    add_column :prod_types, :pack_to, :text
    remove_column :products, :pack_to
  end
end
