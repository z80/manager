class AddSuperitemIdToContractItem < ActiveRecord::Migration
  def change
  	add_column :contract_items, :superitem_id, :integer
  end
end
