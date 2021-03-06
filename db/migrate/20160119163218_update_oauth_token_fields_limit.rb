class UpdateOauthTokenFieldsLimit < ActiveRecord::Migration[5.1]
  def change
    change_column :oauth_access_tokens, :expires_in, :integer, limit: 8, null: true
    change_column :oauth_access_grants, :expires_in, :integer, limit: 8, null: true
  end
end
