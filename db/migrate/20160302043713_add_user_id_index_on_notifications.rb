class AddUserIdIndexOnNotifications < ActiveRecord::Migration[5.1]
  def change
    remove_index :notifications, :read
    add_index :notifications, :user_id
  end
end
