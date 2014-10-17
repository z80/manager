class CreatePartTypes < ActiveRecord::Migration
  def change
    create_table :part_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
