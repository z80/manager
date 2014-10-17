class CreateProdSubtypes < ActiveRecord::Migration
  def change
    create_table :prod_subtypes do |t|
      t.integer :belongs_id
      t.integer :contains_id

      t.timestamps
    end
  end
end
