class AddReplyToIdToReplies < ActiveRecord::Migration[5.1]
  def change
    add_column :replies, :reply_to_id, :integer
  end
end
