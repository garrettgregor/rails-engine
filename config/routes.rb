# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        # namespace :merchants do
        resources :items, only: %i[index], controller: 'merchants/items'
      end
      resources :items, only: %i[index show create update destroy] do
        resources :merchant, only: %i[index], controller: 'items/merchant'
      end
    end
  end
end
