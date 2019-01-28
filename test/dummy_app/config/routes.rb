# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/login' => 'sessions#create', as: :create_session
  delete '/logout' => 'sessions#destroy', as: :destroy_session

  resources :messages
  resources :users

  root to: 'messages#index'
end
