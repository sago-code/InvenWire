class AddPriceAndStockToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :price, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :products, :stock, :integer, default: 0
    add_reference :products, :warehouse, foreign_key: true, null: true
    add_reference :products, :user, foreign_key: true, null: true
  end
end
