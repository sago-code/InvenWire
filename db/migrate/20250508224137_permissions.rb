class Permissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :name_module
      t.timestamps
    end
    add_index :permissions, :name_module, unique: true

    reversible do |dir|
      dir.up do
        [ 'create_user', 'create_inventory', 'view_inventory', 'reception', 'dispatch', 'create_warehouse' ].each do |permission_name|
          execute <<-SQL
            INSERT INTO permissions (name_module, created_at, updated_at)
            VALUES ('#{permission_name}', datetime('now'), datetime('now'))
          SQL
        end
      end
    end
  end
end
