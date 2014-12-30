class AddOrderingPersonIdToPart < ActiveRecord::Migration
  def change
    add_column :parts, :ordering_person_id, :integer
  end
end
