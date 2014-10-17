class AddStatusIToItems < ActiveRecord::Migration
  def change
    add_column :items, :status_i, :integer
  end
end
