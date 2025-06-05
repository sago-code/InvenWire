class Product < ApplicationRecord
  belongs_to :warehouse, optional: true
  belongs_to :user, optional: true
  has_many :inventory_movements
  has_many :inventories

  # Validaciones
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # El stock ya no se maneja directamente en el producto
  # sino a través de la tabla inventory

  # Método para obtener el stock total en todas las bodegas
  def total_stock
    inventories.sum(:product_stock) || 0
  end

  # Método para obtener el stock en una bodega específica
  def stock_in_warehouse(warehouse_id)
    inventories.where(warehouse_id: warehouse_id).sum(:product_stock) || 0
  end
end
