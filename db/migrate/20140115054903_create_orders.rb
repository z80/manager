class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.text    :desc
      t.string  :status

      t.timestamps
    end
  end
end
