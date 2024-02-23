Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  Rails.application.routes.draw do

    post 'authenticate', to: 'authentication#authenticate'

    namespace :api do
      resources :tasks do
        member do
          post :assign
          put :progress
        end
        collection do
          get :overdue
          get :status
          get :completed
          get :statistics
          get :priority
        end
      end

      resources :users do
        member do
          get :tasks
        end
      end
    end
  end
end
