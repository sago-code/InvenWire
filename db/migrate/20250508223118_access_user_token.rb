class AccessUserToken < ActiveRecord::Migration[8.0]
  def change
    create_table :access_user_tokens do |t|
      t.string :token
      t.references :user, foreign_key: true
      t.datetime :expiration_date
      t.boolean :expired, default: false
      t.timestamps
    end
    add_index :access_user_tokens, :token, unique: true
    add_index :access_user_tokens, :expiration_date
    add_index :access_user_tokens, [ :user_id, :token ], unique: true
  end
end
