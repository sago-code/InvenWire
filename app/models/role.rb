class Role < ApplicationRecord
  has_many :user_roles
  has_many :users, through: :user_roles
  has_many :user_permissions
  has_many :permissions, through: :user_permissions

  validates :name, presence: true, uniqueness: true
end
