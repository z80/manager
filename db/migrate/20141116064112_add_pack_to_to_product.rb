class AddPackToToProduct < ActiveRecord::Migration
  def change
    add_column :products, :pack_to, :text
  end
end
