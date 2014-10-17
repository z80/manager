class CreateProductStatuses < ActiveRecord::Migration
  def change
    create_table :product_statuses do |t|
      t.string :status

      t.timestamps
    end
  end
end
