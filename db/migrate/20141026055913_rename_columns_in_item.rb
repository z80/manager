class RenameColumnsInItem < ActiveRecord::Migration
  def change
    rename_column :items, :status_i,    :status_id
    rename_column :items, :contract,    :contract_desc
    rename_column :items, :user_placed, :user_placed_id
    rename_column :items, :user_resp,   :user_resp_id
  end
end
