class AddImageToProdType < ActiveRecord::Migration
  def change
    add_attachment :prod_types, :image
  end
end
