class AddDescTextToImages < ActiveRecord::Migration
  def change
    add_column :images, :desc, :text
  end
end
