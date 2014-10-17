class AddOrderTimeToPart < ActiveRecord::Migration
  def change
    # This is ordering time in days.
    add_column :parts, :order_time, :integer
  end
end
