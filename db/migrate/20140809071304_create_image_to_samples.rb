class CreateImageToSamples < ActiveRecord::Migration
  def change
    create_table :image_to_samples do |t|
      t.integer :image_id
      t.integer :sample_id

      t.timestamps
    end
  end
end
