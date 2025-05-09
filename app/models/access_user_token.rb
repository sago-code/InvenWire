class AccessUserToken < ApplicationRecord
  belongs_to :user

  # Validaciones
  validates :token, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :expiration_date, presence: true

  # Scope para tokens activos
  scope :active, -> { where("expiration_date > ? AND expired = ?", Time.current, false) }

  # Verificar si un token ha expirado
  def expired?
    expired || expiration_date <= Time.current
  end
end
