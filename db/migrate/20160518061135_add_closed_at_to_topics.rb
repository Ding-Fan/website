class AddClosedAtToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :closed_at, :datetime
  end
end
