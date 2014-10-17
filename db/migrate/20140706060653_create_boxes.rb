class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :box_id
      t.text :desc

      t.timestamps
    end
  end
end
