Rails.application.routes.draw do
  # Rutas para autenticación
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Rutas para API
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"

      # API para productos
      resources :products

      # API para inventario
      resources :inventory, only: [ :index ] do
        collection do
          post "add", to: "inventory#add_to_inventory"
          post "remove", to: "inventory#remove_from_inventory"
          get "movements", to: "inventory#movements"
        end
      end
    end
  end

  # Define la ruta raíz
  root "home#index"

  # Rutas para productos e inventario (frontend)
  resources :products
  resources :warehouses

  # Rutas para inventario (frontend)
  resources :inventory, only: [:index] do # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
    collection do
      get "movements"
    end
  end
end
