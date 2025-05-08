class UserPermission < ApplicationRecord
  belongs_to :user
  belongs_to :role
  belongs_to :permission
  
  # Validación para evitar duplicados
  validates :user_id, uniqueness: { scope: [:permission_id, :role_id] }
end