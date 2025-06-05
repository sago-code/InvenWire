# producto.rb
class Product < ApplicationRecord
  belongs_to :warehouse, optional: true  # Si puede no tener bodega
end