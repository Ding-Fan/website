class RemoveOldNotifications < ActiveRecord::Migration[5.1]
  def change
    drop_table :notifications
  end
end
