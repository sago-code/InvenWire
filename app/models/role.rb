class Role < ApplicationRecord
  # Relaciones
  has_many :user_roles
  has_many :users, through: :user_roles
  
  # Validaciones
  validates :name, presence: true, uniqueness: true
end