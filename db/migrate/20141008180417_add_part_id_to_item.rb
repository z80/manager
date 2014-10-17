
class AddPartIdToItem < ActiveRecord::Migration
  def change
  	add_column :items, :part_id, :integer
  end
end



