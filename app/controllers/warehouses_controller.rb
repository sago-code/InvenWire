class WarehousesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_warehouse, only: [ :show, :edit, :update, :destroy ]

  def index
    @warehouses = Warehouse.all.includes(:location)
    render template: "warehouse/index"
  end

  def show
    render template: "warehouse/show"
  end

  def new
    @warehouse = Warehouse.new
    @locations = Location.all
    render template: "warehouse/new"
  end

  def edit
    @locations = Location.all
    render template: "warehouse/edit"
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)

    if @warehouse.save
      redirect_to warehouse_path(@warehouse), notice: "Bodega creada con éxito."
    else
      @locations = Location.all
      render :new
    end
  end

  def update
    if @warehouse.update(warehouse_params)
      redirect_to warehouse_path(@warehouse), notice: "Bodega actualizada con éxito."
    else
      @locations = Location.all
      render :edit
    end
  end

  def destroy
    @warehouse.destroy
    redirect_to warehouses_path, notice: "Bodega eliminada."
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find(params[:id])
  end

  def warehouse_params
    params.require(:warehouse).permit(:name, :location_id, :address)
  end
end
