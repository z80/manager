class AddImageToPart < ActiveRecord::Migration
  def change
    add_attachment :parts, :image
  end
end
