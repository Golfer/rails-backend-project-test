# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :companies
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
