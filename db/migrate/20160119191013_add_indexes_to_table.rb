class AddIndexesToTable < ActiveRecord::Migration[5.1]
  def change
    add_index :topics, :deleted_at
    add_index :topics, [:node_id, :deleted_at]

    add_index :replies, :deleted_at
    add_index :replies, [:topic_id, :deleted_at]

    add_index :sites, :deleted_at
    add_index :sites, [:site_node_id, :deleted_at]

    remove_index :users, :location
    add_index :users, :location

    add_index :nodes, :sort
  end
end
