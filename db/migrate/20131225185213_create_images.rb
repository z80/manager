class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :desc
      t.timestamps
    end
  end
end
