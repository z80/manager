class AddUserIdToPartInst < ActiveRecord::Migration
  def change
    add_column :part_insts, :user_id, :integer
  end
end
