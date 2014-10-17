class AddTypeToParts < ActiveRecord::Migration
  def change
    add_column :parts, :type, :integer
  end
end
