class AddBoxIdToSample < ActiveRecord::Migration
  def change
    add_column :samples, :box_id, :integer
  end
end
