class AddUserToProdType < ActiveRecord::Migration
  def change
  	add_column :prod_types, :user_id, :integer
  end
end
