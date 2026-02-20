# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :auth do
        post :register, to: "registrations#create"
        post :login, to: "sessions#create"
        get :me, to: "me#show"
      end

      resources :companies do
        resource :current_onboarding_step, only: [ :show ], module: :companies
        resource :sync_progress, only: [ :show ], module: :companies, controller: "sync_progress"
        resources :onboarding_step_statuses, only: [ :index ], module: :companies
      end
      resources :onboarding_steps
      resources :onboarding_processes
      resources :onboarding_step_submissions
      resources :vendors
      resources :warehouses
      resources :products
      resources :sales_history
      resources :sync_statuses
      resources :users
    end
  end

  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"
end
