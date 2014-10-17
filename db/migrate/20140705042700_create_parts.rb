class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :own_id
      t.string :third_id
      t.integer :user_id
      t.integer :cnt

      t.timestamps
    end
  end
end
