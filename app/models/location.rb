class Location < ApplicationRecord
  has_many :warehouses
  
  validates :name, presence: true, uniqueness: true
 end