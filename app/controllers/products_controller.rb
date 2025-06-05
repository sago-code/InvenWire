# app/controllers/productos_controller.rb
class ProductsController < ApplicationController
  def new
    @producto = Product.new
  end
  
  def index
    @producto = Product.all
  end

  def show
    @producto = Product.find(params[:id])
  end

  def create
    @producto = Product.new(product_params)
    if @producto.save
      redirect_to @producto, notice: 'Producto creado con éxito.'
    else
      render :new
    end
  end

  def edit
    @producto = Product.find(params[:id])
  end

  def update
    @producto = Product.find(params[:id])
    if @producto.update(product_params)
      redirect_to @producto, notice: 'Producto actualizado con éxito.'
    else
      render :edit
    end
  end

  def destroy
    @producto = Product.find(params[:id])
    @producto.destroy
    redirect_to productos_path, notice: 'Producto eliminado.'
  end
  
  private

  def product_params
    params.require(:producto).permit(:name, :description, :price, :stock, :warehouse_id)
  end
end