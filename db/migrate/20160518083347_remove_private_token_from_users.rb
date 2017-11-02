class RemovePrivateTokenFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :private_token
  end
end
