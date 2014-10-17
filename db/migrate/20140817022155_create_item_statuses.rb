class CreateItemStatuses < ActiveRecord::Migration
  def change
    create_table :item_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
