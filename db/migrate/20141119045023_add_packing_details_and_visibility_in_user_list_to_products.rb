class AddPackingDetailsAndVisibilityInUserListToProducts < ActiveRecord::Migration
  def change
    add_column :prod_types, :packing_details, :text
    add_column :prod_types, :client_visible,  :boolean
  end
end
