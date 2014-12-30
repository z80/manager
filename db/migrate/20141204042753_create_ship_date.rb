class CreateShipDate < ActiveRecord::Migration
  def change
    create_table :ship_dates do |t|
      t.integer :contract_id
      t.date    :date

      t.timestamps
    end
  end
end


