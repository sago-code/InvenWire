class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # Página principal después del login
  end
end
