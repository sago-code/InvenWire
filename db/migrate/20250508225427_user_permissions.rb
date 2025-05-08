class UserPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_permissions do |t|
      t.references :user, foreign_key: true
      t.references :role, foreign_key: true
      t.references :permission, foreign_key: true
      t.timestamps
    end
    add_index :user_permissions, [ :user_id, :permission_id, :role_id ], unique: true
  end
end
