class CreateInventoryMovements < ActiveRecord::Migration[8.0]
  def change
    create_table :inventory_movements do |t|
      t.references :product, foreign_key: true
      t.references :warehouse, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :quantity
      t.string :movement_type
      t.string :description
      t.timestamps
    end
  end
end
