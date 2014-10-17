class AddBelongsIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :belongs_id, :integer
  end
end
