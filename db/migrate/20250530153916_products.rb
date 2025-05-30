class Products < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.boolean :is_final_product
      t.timestamps
    end

    create_table :locations do |t|
      t.string :name
      t.timestamps
    end

    create_table :warehouses do |t|
      t.string :name
      t.references :location, foreign_key: true, index: { unique: true }
      t.string :address
      t.timestamps
    end

    create_table :product_states do |t|
      t.string :name
      t.timestamps
    end

    create_table :inventories do |t|
      t.references :product, foreign_key: true
      t.references :warehouse, foreign_key: true
      t.integer :product_stock
      t.references :product_state, foreign_key: true
      t.timestamps
    end
    add_index :inventories, [ :product_id, :warehouse_id, :product_state_id ], unique: true, name: 'index_inventories_on_product_warehouse_state'
  end
end
