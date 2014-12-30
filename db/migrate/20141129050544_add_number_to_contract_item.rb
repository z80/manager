class AddNumberToContractItem < ActiveRecord::Migration
  def change
    add_column :contract_items, :number, :string
  end
end
