class User < ApplicationRecord
    has_secure_password

    # Relaciones
    has_many :user_roles
    has_many :roles, through: :user_roles

    # Validaciones
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :document, presence: true, uniqueness: true
    validates :phone, presence: true, uniqueness: true
    validates :first_name, :last_name, presence: true
    validates :password, presence: true, length: { minimum: 6 }, on: :create
end