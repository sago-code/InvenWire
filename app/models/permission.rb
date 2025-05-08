class Permission < ApplicationRecord
  has_many :user_permissions
  has_many :users, through: :user_permissions
  
  validates :name_module, presence: true, uniqueness: true
end