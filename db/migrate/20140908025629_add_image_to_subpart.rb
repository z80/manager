class AddImageToSubpart < ActiveRecord::Migration
  def change
    create_table :image_to_subparts do |t|
      t.integer :image_id
      t.integer :subpart_id

      t.timestamps
    end
  end
end
