class AddAttachmentToPart < ActiveRecord::Migration
  def change
    create_table :attachment_to_parts do |t|
      t.integer :attachment_id
      t.integer :part_id

      t.timestamps
    end
  end
end
