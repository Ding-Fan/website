class AddTextPatternOptsToUsers < ActiveRecord::Migration[5.1]
  def change
    # UPDATE users SET name = substring(name, 99) WHERE length(name) >= 100
    change_column :users, :username, :string, limit: 100
    add_index :users, 'lower(username) varchar_pattern_ops'
  end
end
