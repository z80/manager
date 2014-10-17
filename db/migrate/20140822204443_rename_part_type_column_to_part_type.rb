class RenamePartTypeColumnToPartType < ActiveRecord::Migration
  def change
    rename_column :parts, :type, :part_type
  end
end
