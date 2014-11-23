class CreateAttachment2ContractAndAttachment2ProductAndAttachment2ProdType < ActiveRecord::Migration
  def change
    create_table :attachment_to_contracts do |t|
    	t.integer :attachment_id
    	t.integer :contract_id

    	t.timestamps
    end

    create_table :attachment_to_products do |t|
    	t.integer :attachment_id
        t.integer :product_id

    	t.timestamps
    end

	create_table :attachment_to_prod_types do |t|
    	t.integer :attachment_id
    	t.integer :prod_type_id
    	
    	t.timestamps
	end
  end
end
