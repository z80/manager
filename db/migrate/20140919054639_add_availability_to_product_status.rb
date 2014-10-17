class AddAvailabilityToProductStatus < ActiveRecord::Migration
  def change
    add_column :product_statuses, :avail, :boolean
  end
end
