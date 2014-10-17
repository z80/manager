class CreateImageToParts < ActiveRecord::Migration
  def change
    create_table :image_to_parts do |t|
      t.integer :image_id
      t.integer :part_id

      t.timestamps
    end
  end
end
