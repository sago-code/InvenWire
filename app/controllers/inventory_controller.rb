class InventoryController  < ApplicationController
  def index
    @productos = Product.all.includes(:warehouse, :user)
  end
end
