class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string  :supplier_id
      t.string  :internal_id
      t.text    :desc
      t.string  :order_link
      t.string  :contract_id
      t.text    :deliver_addr
      t.string  :status
      t.integer :user_placed
      t.integer :user_resp
      t.integer :set_sz
      t.integer :sets_cnt
      t.decimal :unit_price, :precision => 10, :scale => 4
      t.text    :comment

      t.timestamps
    end
  end
end
