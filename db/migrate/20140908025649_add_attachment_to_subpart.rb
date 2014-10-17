class AddAttachmentToSubpart < ActiveRecord::Migration
  def change
    create_table :attachment_to_subparts do |t|
      t.integer :attachment_id
      t.integer :subpart_id

      t.timestamps
    end
  end
end
