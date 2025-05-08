module Api
  module V1
    class UsersController < ApplicationController
      # Saltamos la verificación del token CSRF para APIs
      skip_before_action :verify_authenticity_token

      def create
        @user = User.new(user_params)

        User.transaction do
          if @user.save
            # Asignar roles
            if params[:roles].present?
              params[:roles].each do |role_id|
                @user.user_roles.create(role_id: role_id)
              end
            end

            # Asignar permisos
            if params[:permissions].present?
              params[:permissions].each do |permission_data|
                @user.user_permissions.create(
                  permission_id: permission_data[:permission_id],
                  role_id: permission_data[:role_id]
                )
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

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :document, :phone, :email, :password, :password_confirmation)
      end
    end
  end
end
