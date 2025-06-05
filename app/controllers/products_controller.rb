class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

  def index
    @products = Product.all.includes(:warehouse)
  end

  def show
  end

  def new
    @product = Product.new
    @warehouses = Warehouse.all
  end

  def edit
    @warehouses = Warehouse.all
  end

  def create
    @product = Product.new(product_params)
    @product.user = current_user

    if @product.save
      # Si se especificó una bodega y stock inicial, crear el inventario
      if params[:add_to_inventory] == "1" && params[:stock].present? && params[:stock].to_i > 0 && @product.warehouse.present?
        inventory = Inventory.create(
          product: @product,
          warehouse: @product.warehouse,
          product_stock: params[:stock].to_i,
          product_state_id: 1 # Estado por defecto
        )

        if inventory.persisted?
          # Registrar movimiento de inventario
          InventoryMovement.create(
            product: @product,
            warehouse: @product.warehouse,
            user: current_user,
            quantity: params[:stock].to_i,
            movement_type: "entrada",
            description: "Stock inicial"
          )
        end
      end

      redirect_to @product, notice: "Producto creado con éxito."
    else
      @warehouses = Warehouse.all
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Producto actualizado con éxito."
    else
      @warehouses = Warehouse.all
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Producto eliminado."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :warehouse_id)
  end
end
