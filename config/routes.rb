Rails.application.routes.draw do
  # Rutas para autenticación
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Rutas para API
  namespace :api do
    namespace :v1 do
      resources :users, only: [ :create ]
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
    end
  end

  # Define la ruta raíz
  root "home#index"
  # Rutas para la página de inicio
  resources :products
  resources :bodegas
  resources :inventory, only: [:index]

  # Otras rutas de tu aplicación...
end