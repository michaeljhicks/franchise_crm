# config/routes.rb

Rails.application.routes.draw do
  get "communications/show"
  get "google_connections/destroy"
  # 1. Set the root path for logged-in users.
  root "dashboard#index"

  # 2. Set up Devise, pointing to our custom callbacks controller.
  # This single line handles all sign-in, sign-up, and omniauth routes correctly.
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  # 3. Define the admin-only area.
  namespace :admin do
    root to: "dashboard#index"
  end

  # 4. Define all your application's resources and custom actions.
  resources :customers do
    resources :machines do
      resources :jobs # This handles create, new, edit, etc.
    end
  end
  
  resources :machines, only: [:index] do
    get :boneyard, on: :collection
  end
  
  resources :contractors
  
  resources :lease_agreements do
    member do
      get :generate_document
    end
  end
  
  resources :jobs, only: [:index, :show] do
    member do
      patch :complete
      get :reschedule
    end
  end
  
  resources :tasks, only: [] do
    member do
      patch :toggle
    end
  end
  
  resources :prospects do
    member do
      post :convert
    end
  end

  resource :google_connection, only: [:destroy]
  resources :communications, only: [:show]


  # 5. Rails default health check route.
  get "up" => "rails/health#show", as: :rails_health_check
end