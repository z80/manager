class AddNumberToContract < ActiveRecord::Migration
  def change
    add_column :contracts, :number, :string
  end
end
