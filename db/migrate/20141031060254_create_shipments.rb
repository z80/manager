class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.integer :contract_id
      t.string :desc

      t.timestamps
    end
  end
end
