Rails.application.routes.draw do
  # Rutas para autenticación
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Rutas para API
  namespace :api do
    namespace :v1 do
      resources :users, only: [ :create, :index ]
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
    end
  end

  # Rutas para administración
  namespace :admin do
    resources :users
  end

  # Define la ruta raíz
  root "home#index"

  # Otras rutas de tu aplicación...
end
