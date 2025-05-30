class SessionsController < ApplicationController
  # Saltamos la verificación del token CSRF para APIs si es necesario
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy], if: -> { request.format.json? }

  def new
    # Vista para el formulario de login
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      # Generar un token único
      token = SecureRandom.urlsafe_base64(32)

      # Establecer fecha de expiración (7 días)
      expiration_date = 7.days.from_now

      token_created = false
      error_message = nil

      begin
        # Crear registro de token en la base de datos
        AccessUserToken.create!(
          token: token,
          user_id: user.id,
          expiration_date: expiration_date,
          expired: false
        )
        token_created = true
      rescue ActiveRecord::RecordInvalid => e
        error_message = "Error de validación: #{e.message}"
        Rails.logger.error error_message
      rescue ActiveRecord::StatementInvalid => e
        error_message = "Error de SQL: #{e.message}"
        Rails.logger.error error_message
      rescue NameError => e
        error_message = "Error de nombre de clase: #{e.message}"
        Rails.logger.error error_message
      rescue => e
        error_message = "Error desconocido: #{e.message}"
        Rails.logger.error error_message
        Rails.logger.error e.backtrace.join("\n")
      end

      # Almacenar el ID de usuario en la sesión
      session[:user_id] = user.id
      session[:token] = token if token_created

      # Almacenar el token en cookies para acceso desde JavaScript
      if token_created
        # Crear un objeto de datos de usuario
        user_data = {
          id: user.id,
          email: user.email,
          name: "#{user.first_name} #{user.last_name}"
        }

        # Establecer cookies con valores simples (sin caracteres especiales)
        cookies[:auth_token] = {
          value: token,
          expires: expiration_date,
          httponly: false # Permitir acceso desde JavaScript
        }

        # Convertir a JSON y codificar para evitar problemas con caracteres especiales
        cookies[:user_data] = {
          value: user_data.to_json,
          expires: expiration_date,
          httponly: false # Permitir acceso desde JavaScript
        }
      end

      respond_to do |format|
        format.html {
          # Redirigir con parámetro para indicar inicio de sesión reciente
          redirect_to root_path(just_logged_in: true), notice: "Sesión iniciada correctamente"
        }
        format.json {
          render json: {
            message: "Sesión iniciada correctamente",
            user: user,
            token: token,
            expires_at: expiration_date
          }, status: :ok
        }
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:alert] = "Email o contraseña inválidos"
          render :new, status: :unprocessable_entity
        }
        format.json { render json: { errors: [ "Email o contraseña inválidos" ] }, status: :unauthorized }
      end
    end
  end

  def destroy
    # Invalidar el token en la base de datos
    if session[:token].present?
      access_token = AccessUserToken.find_by(token: session[:token])
      access_token.update(expired: true) if access_token
    end

    # Limpiar la sesión
    session[:user_id] = nil
    session[:token] = nil

    # Limpiar las cookies
    cookies.delete(:auth_token)
    cookies.delete(:user_data)

    # Agregar script para limpiar localStorage y sessionStorage
    @clear_storage_script = "<script>localStorage.removeItem('authToken'); localStorage.removeItem('user'); sessionStorage.removeItem('authToken'); sessionStorage.removeItem('user');</script>"

    respond_to do |format|
      format.html {
        # Redirigir con un script para limpiar el almacenamiento
        flash[:clear_storage] = true
        redirect_to login_path, notice: "Sesión cerrada correctamente"
      }
      format.json { render json: { message: "Sesión cerrada correctamente" }, status: :ok }
    end
  end
end
