# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  get 'up' => 'rails/health#show', as: :rails_health_check

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

  namespace :api do
    resources :products, only: %i[index create update destroy] do
      collection do
        get :search
      end
    end

    get 'products/approval-queue', to: 'approval_queues#index', as: 'approval_queue'
    put 'products/approval-queue/:id/approve', to: 'approval_queues#approve', as: 'approve_product'
    put 'products/approval-queue/:id/reject', to: 'approval_queues#reject', as: 'reject_product'
  end
end
