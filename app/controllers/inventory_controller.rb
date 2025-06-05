class InventoryController < ApplicationController
  before_action :authenticate_user!

  def index
    @productos = Product.all.includes(:warehouse, :user)
  end

  def movements
    @product = Product.find(params[:product_id]) if params[:product_id].present?
    @movements = InventoryMovement.all
    @movements = @movements.where(product_id: params[:product_id]) if params[:product_id].present?
    @movements = @movements.where(warehouse_id: params[:warehouse_id]) if params[:warehouse_id].present?
    @movements = @movements.order(created_at: :desc).includes(:product, :warehouse, :user)
  end
end
