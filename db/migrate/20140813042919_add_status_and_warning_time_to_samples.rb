class AddStatusAndWarningTimeToSamples < ActiveRecord::Migration
  def change
    add_column :samples, :status,    :integer
    add_column :samples, :warn_days, :integer
  end
end
