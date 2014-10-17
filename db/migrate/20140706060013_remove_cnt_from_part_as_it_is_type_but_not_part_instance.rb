class RemoveCntFromPartAsItIsTypeButNotPartInstance < ActiveRecord::Migration
  def change
    remove_column :parts, :cnt
    add_column    :parts, :desc, :text
  end
end
