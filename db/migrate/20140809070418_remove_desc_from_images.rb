class RemoveDescFromImages < ActiveRecord::Migration
  def change
    remove_column :images, :desc
  end
end
