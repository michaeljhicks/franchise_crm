Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    get "dashboard/index"
  end
  
  resources :customers do
    resources :machines do
      resources :jobs
    end
  end
  resources :machines, only: [:index]
  resources :contractors

  namespace :admin do
    root to: "dashboard#index"
    # In the future, you can add more admin-only resources here, like:
    # resources :users
    # resources :customers
  end

  root "customers#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
