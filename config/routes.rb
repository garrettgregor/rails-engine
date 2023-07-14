# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # Doesn't work: get '/api/v1/merchants/find', to: 'merchants/search#show'

  namespace :api do
    namespace :v1 do
      # Question: how to handroll this or use resources?
      get '/merchants/find_all', to: 'merchants/search#index'
      get '/merchants/find', to: 'merchants/search#show'
      resources :merchants, only: %i[index show] do
        resources :items, only: %i[index], controller: 'merchants/items'
      end
      resources :items, only: %i[index show create update destroy] do
        resources :merchant, only: %i[index], controller: 'items/merchant'
      end
    end
  end
end
