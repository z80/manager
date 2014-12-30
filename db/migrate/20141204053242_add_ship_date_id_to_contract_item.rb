class AddShipDateIdToContractItem < ActiveRecord::Migration
  def change
    add_column :contract_items, :ship_date_id, :integer
  end
end
