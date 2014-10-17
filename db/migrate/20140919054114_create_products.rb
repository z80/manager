class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :prod_type_id
      t.string :serial_number
      t.text :desc
      t.integer :status

      t.timestamps
    end
  end
end
