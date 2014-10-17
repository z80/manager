class CreateWarehouses < ActiveRecord::Migration
  def change
    create_table :warehouses do |t|
      t.string :w_id
      t.text :w_desc

      t.timestamps
    end
  end
end
