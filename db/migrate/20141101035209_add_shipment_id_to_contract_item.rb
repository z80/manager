class AddShipmentIdToContractItem < ActiveRecord::Migration
  def change
    add_column :contract_items, :shipment_id, :integer
  end
end
