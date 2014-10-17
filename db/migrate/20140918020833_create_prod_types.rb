class CreateProdTypes < ActiveRecord::Migration
  def change
    create_table :prod_types do |t|
      t.integer :part_id
      t.string :own_id
      t.text :desc

      t.timestamps
    end
  end
end
