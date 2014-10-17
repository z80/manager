class AddAttachmentToOrder < ActiveRecord::Migration
  def change
    add_attachment :orders, :attachment
  end
end
