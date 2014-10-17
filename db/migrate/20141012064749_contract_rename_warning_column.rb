class ContractRenameWarningColumn < ActiveRecord::Migration
  def change
    rename_column :contracts, :warning_level, :warning
  end
end
