class AddExpiredToAccessUserTokens < ActiveRecord::Migration[8.0]
  def change
    add_column :access_user_tokens, :expired, :boolean
  end
end
