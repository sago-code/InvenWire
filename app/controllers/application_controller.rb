class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :user_signed_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless user_signed_in?
      respond_to do |format|
        format.html { redirect_to login_path, alert: "Debes iniciar sesión para acceder" }
        format.json { render json: { errors: [ "No autorizado" ] }, status: :unauthorized }
      end
    end
  end

  # Método para autenticar mediante token API
  def authenticate_api_user!
    token = request.headers["Authorization"]&.split(" ")&.last

    unless token
      render json: { errors: ["Token no proporcionado"] }, status: :unauthorized # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
      return
    end

    access_token = AccessUserToken.find_by(token: token, expired: false)

    if access_token && !access_token.expired?
      @current_api_user = access_token.user
    else
      render json: { errors: [ "Token inválido o expirado" ] }, status: :unauthorized
    end
  end

  # Método para verificar si el usuario actual es administrador
  def require_admin!
    unless current_user&.admin?
      respond_to do |format|
        format.html { redirect_to root_path, alert: "No tienes permisos para acceder a esta sección" }
        format.json { render json: { errors: ["Acceso denegado"] }, status: :forbidden } # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
      end
    end
  end

  # Método para verificar si el usuario API es administrador
  def require_api_admin!
    unless @current_api_user&.admin?
      render json: { errors: ["No tienes permisos para realizar esta acción"] }, status: :forbidden # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
    end
  end

  # Método para verificar si el usuario tiene un permiso específico
  def require_permission!(permission_name)
    unless current_user&.has_permission?(permission_name)
      respond_to do |format|
        format.html { redirect_to root_path, alert: "No tienes permisos para acceder a esta sección" }
        format.json { render json: { errors: [ "Acceso denegado" ] }, status: :forbidden }
      end
    end
  end
end
