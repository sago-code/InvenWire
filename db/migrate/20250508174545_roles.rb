class Roles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    add_index :roles, :name, unique: true
    
    # Crear roles por defecto directamente en la migración
    reversible do |dir|
      dir.up do
        # Crear los roles básicos
        ['admin', 'employee', 'supervisor'].each do |role_name|
          execute <<-SQL
            INSERT INTO roles (name, created_at, updated_at) 
            VALUES ('#{role_name}', datetime('now'), datetime('now'))
          SQL
        end
      end
    end
  end
end