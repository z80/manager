class AddOrderDateAndContractIdToItem < ActiveRecord::Migration
  def change
  	add_column    :items, :order_date,  :date
  	rename_column :items, :contract_id, :contract
  	add_column    :items, :contract_id, :integer
  end
end
