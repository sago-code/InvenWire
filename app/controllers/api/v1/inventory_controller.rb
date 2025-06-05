module Api
  module V1
    class InventoryController < ApplicationController
      skip_before_action :verify_authenticity_token

      def index
        @inventories = Inventory.all.includes(:product, :warehouse, :product_state)
        render json: @inventories
      end

      def add_to_inventory
        @product = Product.find(params[:product_id])
        @warehouse = Warehouse.find(params[:warehouse_id])
        quantity = params[:quantity].to_i

        # Buscar o crear el registro de inventario
        @inventory = Inventory.find_or_initialize_by(
          product_id: @product.id,
          warehouse_id: @warehouse.id,
          product_state_id: params[:product_state_id] || 1 # Estado por defecto
        )

        # Actualizar el stock
        @inventory.product_stock = (@inventory.product_stock || 0) + quantity

        if @inventory.save
          # Registrar el movimiento
          InventoryMovement.create(
            product: @product,
            warehouse: @warehouse,
            user: current_user,
            quantity: quantity,
            movement_type: "entrada",
            description: params[:description] || "Adición al inventario"
          )

          render json: @inventory, status: :ok
        else
          render json: { errors: @inventory.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def remove_from_inventory
        @product = Product.find(params[:product_id])
        @warehouse = Warehouse.find(params[:warehouse_id])
        quantity = params[:quantity].to_i.abs # Asegurar que sea positivo

        # Buscar el registro de inventario
        @inventory = Inventory.find_by(
          product_id: @product.id,
          warehouse_id: @warehouse.id,
          product_state_id: params[:product_state_id] || 1 # Estado por defecto
        )

        if @inventory.nil?
          render json: { error: "No hay inventario para este producto en esta bodega" }, status: :not_found
          return
        end

        # Verificar que haya suficiente stock
        if @inventory.product_stock < quantity
          render json: { error: "Stock insuficiente" }, status: :unprocessable_entity
          return
        end

        # Actualizar el stock
        @inventory.product_stock -= quantity

        if @inventory.save
          # Registrar el movimiento
          InventoryMovement.create(
            product: @product,
            warehouse: @warehouse,
            user: current_user,
            quantity: -quantity, # Negativo para salidas
            movement_type: "salida",
            description: params[:description] || "Retiro del inventario"
          )

          render json: @inventory, status: :ok
        else
          render json: { errors: @inventory.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def movements
        query = InventoryMovement.all.includes(:product, :warehouse, :user)

        query = query.where(product_id: params[:product_id]) if params[:product_id].present?
        query = query.where(warehouse_id: params[:warehouse_id]) if params[:warehouse_id].present?

        @movements = query.order(created_at: :desc)

        render json: @movements
      end
    end
  end
end
