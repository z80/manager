class AddFileToImageModel < ActiveRecord::Migration
  #def change
  #  add_attachment :images, :avatar
  #end

  def self.up
    add_attachment :images, :avatar
  end

  def self.down
    remove_attachment :images, :avatar
  end
end
