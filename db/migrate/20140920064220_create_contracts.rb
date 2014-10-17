class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :name
      t.text :desc
      t.date :ship_date
      t.boolean :shipped

      t.timestamps
    end
  end
end
