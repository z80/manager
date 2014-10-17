class AddSubtypeIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :prod_subtype_id, :integer
  end
end
