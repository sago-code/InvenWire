module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

      def create
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          # Generar un token único
          token = SecureRandom.urlsafe_base64(32)

          # Establecer fecha de expiración (7 días)
          expiration_date = 7.days.from_now

          # Crear registro de token en la base de datos
          access_token = AccessUserToken.create!(
            token: token,
            user_id: user.id,
            expiration_date: expiration_date,
            expired: false
          )

          # Devolver el token y la información del usuario
          render json: {
            message: "Sesión iniciada correctamente",
            user: user,
            token: token,
            token_id: access_token.id,
            expires_at: expiration_date
          }, status: :ok
        else
          render json: { errors: [ "Email o contraseña inválidos" ] }, status: :unauthorized
        end
      end

      def destroy
        # Invalidar el token si se proporciona
        if request.headers["Authorization"].present?
          token = request.headers["Authorization"].split(" ").last
          access_token = AccessUserToken.find_by(token: token)

          if access_token
            access_token.update(expired: true)
          end
        end

        render json: { message: "Sesión cerrada correctamente" }, status: :ok
      end
    end
  end
end
