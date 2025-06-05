module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    def index
      @users = User.all
    end

    def new
      @user = User.new
      @roles = Role.all
      @permissions = Permission.all
    end

    def create
      @user = User.new(user_params)

      User.transaction do
        if @user.save
          # Asignar rol (solo uno)
          if params[:user][:role_ids].present?
            role_id = params[:user][:role_ids].first
            @user.user_roles.create(role_id: role_id) if role_id.present?
          end

          # Asignar permisos a módulos
          if params[:user][:permission_ids].present?
            params[:user][:permission_ids].each do |permission_id|
              next if permission_id.blank?
              # Obtenemos el rol asignado al usuario
              role_id = @user.user_roles.first&.role_id
              if role_id.present?
                @user.user_permissions.create(
                  permission_id: permission_id,
                  role_id: role_id
                )
              end
            end
          end

          redirect_to admin_users_path, notice: "Usuario creado exitosamente"
        else
          @roles = Role.all
          @permissions = Permission.all
          render :new, status: :unprocessable_entity
        end
      end
    end

    def edit
      @user = User.find(params[:id])
      @roles = Role.all
      @permissions = Permission.all
    end

    def update
      @user = User.find(params[:id])

      User.transaction do
        # Actualizar atributos básicos
        if @user.update(user_params)
          # Actualizar rol (solo uno)
          if params[:user][:role_ids].present?
            # Eliminar roles existentes
            @user.user_roles.destroy_all

            # Asignar nuevo rol
            role_id = params[:user][:role_ids].first
            @user.user_roles.create(role_id: role_id) if role_id.present?
          end

          # Actualizar permisos
          if params[:user][:permission_ids].present?
            # Eliminar permisos existentes
            @user.user_permissions.destroy_all

            # Asignar nuevos permisos
            role_id = @user.user_roles.first&.role_id
            if role_id.present?
              params[:user][:permission_ids].each do |permission_id|
                next if permission_id.blank?
                @user.user_permissions.create(
                  permission_id: permission_id,
                  role_id: role_id
                )
              end
            end
          end

          redirect_to admin_users_path, notice: "Usuario actualizado exitosamente"
        else
          @roles = Role.all
          @permissions = Permission.all
          render :edit, status: :unprocessable_entity
        end
      end
    end

    def destroy
      @user = User.find(params[:id])

      if @user.destroy
        redirect_to admin_users_path, notice: "Usuario eliminado exitosamente"
      else
        redirect_to admin_users_path, alert: "No se pudo eliminar el usuario"
      end
    end

    private

    def user_params
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params.require(:user).permit(:first_name, :last_name, :document, :phone, :email)
      else
        params.require(:user).permit(:first_name, :last_name, :document, :phone, :email, :password, :password_confirmation)
      end
    end
  end
end
