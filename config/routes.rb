# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :events do
    resources :attendees
  end
  
  scope '/admin' do
    get '/', to: 'admin#index'
    get '/all_users', to: 'admin#all_users'
  end

  get '*unmatched_route', to: 'pages#not_found'

  root 'pages#index'
end
