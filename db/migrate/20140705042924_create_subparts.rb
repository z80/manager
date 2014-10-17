class CreateSubparts < ActiveRecord::Migration
  def change
    create_table :subparts do |t|
      t.integer :contains_id
      t.integer :belongs_id

      t.timestamps
    end
  end
end
