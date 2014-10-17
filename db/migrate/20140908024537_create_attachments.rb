class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.text :desc

      t.timestamps
    end
  end
end
