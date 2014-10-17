class CreatePartInsts < ActiveRecord::Migration
  def change
    create_table :part_insts do |t|
      t.integer :part_id
      t.integer :box_id
      t.integer :cnt

      t.timestamps
    end
  end
end
