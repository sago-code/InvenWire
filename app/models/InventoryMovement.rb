class InventoryMovement < ApplicationRecord
  belongs_to :product
  belongs_to :warehouse
  belongs_to :user
  # Campos sugeridos: tipo (entrada/salida), cantidad, fecha, etc.
end