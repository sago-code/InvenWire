module Api
    module V1
        class UsersController < ApplicationController
            # Desactivar la protección CSRF para APIs
            skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
            
            # POST /api/v1/users
            def create
                @user = User.new(user_params)
                
                if @user.save
                # Asignar rol por defecto si existe
                default_role = Role.find_by(name: 'usuario')
                @user.roles << default_role if default_role
                
                render json: { 
                    status: 'success', 
                    message: 'Usuario creado exitosamente', 
                    data: user_response(@user) 
                }, status: :created
                else
                render json: { 
                    status: 'error', 
                    message: 'Error al crear usuario', 
                    errors: @user.errors.full_messages 
                }, status: :unprocessable_entity
                end
            end
            
            private
            
            def user_params
                params.require(:user).permit(:first_name, :last_name, :document, :phone, :email, :password, :password_confirmation)
            end
            
            def user_response(user)
                {
                id: user.id,
                first_name: user.first_name,
                last_name: user.last_name,
                document: user.document,
                phone: user.phone,
                email: user.email,
                roles: user.roles.pluck(:name)
                }
            end
        end
    end
end