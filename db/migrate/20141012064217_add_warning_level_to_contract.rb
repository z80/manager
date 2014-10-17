class AddWarningLevelToContract < ActiveRecord::Migration
  def change
    add_column :contracts, :warning_level, :integer
  end
end
