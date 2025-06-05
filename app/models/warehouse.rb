class Warehouse < ApplicationRecord
  belongs_to :location, optional: true
  has_many :products
  has_many :inventory_movements

  validates :name, presence: true
end
