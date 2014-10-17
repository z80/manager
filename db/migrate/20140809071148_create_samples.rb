class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.text :from
      t.text :desc
      t.datetime :received
      t.datetime :due
      t.integer :user_placed
      t.integer :user_resp

      t.timestamps
    end
  end
end
