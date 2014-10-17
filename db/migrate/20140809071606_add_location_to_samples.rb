class AddLocationToSamples < ActiveRecord::Migration
  def change
    add_column :samples, :location, :text
  end
end
