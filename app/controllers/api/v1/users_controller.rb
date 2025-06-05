module Api
  module V1
    class UsersController < ApplicationController
      # Saltamos la verificación del token CSRF para APIs
      skip_before_action :verify_authenticity_token
      # Requerimos autenticación y permisos de administrador
      before_action :authenticate_api_user!
      before_action :require_api_admin!

      def create
        @user = User.new(user_params)

        User.transaction do
          if @user.save
            # Asignar rol (solo uno)
            if params[:role_id].present?
              @user.user_roles.create(role_id: params[:role_id])
            end

            # Asignar permisos
            if params[:permission_ids].present?
              role_id = @user.user_roles.first&.role_id
              if role_id.present?
                params[:permission_ids].each do |permission_id|
                  @user.user_permissions.create(
                    permission_id: permission_id,
                    role_id: role_id
                  )
                end
              end
            end

            render json: {
              message: "Usuario creado exitosamente",
              user: @user,
              roles: @user.roles,
              permissions: @user.permissions
            }, status: :created
          else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
            raise ActiveRecord::Rollback
          end
        end
      end

      def index
        @users = User.all
        render json: { users: @users }, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :document, :phone, :email, :password, :password_confirmation)
      end
    end
  end
end
