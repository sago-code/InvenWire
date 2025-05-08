class Users < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :document
      t.string :phone
      t.string :email
      t.string :password_digest
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :document, unique: true
    add_index :users, :phone, unique: true
  end
end
