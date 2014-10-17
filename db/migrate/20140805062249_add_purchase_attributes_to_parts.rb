class AddPurchaseAttributesToParts < ActiveRecord::Migration
  def change
    add_column :parts, :min_cnt,     :integer
    add_column :parts, :order_link,  :text
    add_column :parts, :order_desc,  :text
    add_column :parts, :order_price, :decimal, :precision => 10, :scale => 4
  end
end
