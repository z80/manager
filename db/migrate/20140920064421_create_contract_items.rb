class CreateContractItems < ActiveRecord::Migration
  def change
    create_table :contract_items do |t|
      t.integer :contract_id
      t.integer :prod_type_id
      t.integer :product_id

      t.timestamps
    end
  end
end
