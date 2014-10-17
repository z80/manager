class AddUserToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :user, :integer
  end
end
