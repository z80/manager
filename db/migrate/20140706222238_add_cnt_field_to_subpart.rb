class AddCntFieldToSubpart < ActiveRecord::Migration
  def change
    add_column :subparts, :cnt, :integer
  end
end
