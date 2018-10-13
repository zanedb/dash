# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :events do
    resources :attendees

    resources :organizer_position_invites, path: 'invites' do
      post 'accept'
      post 'reject'
    end
  end

  scope '/admin' do
    get '/', to: 'admin#index'
    get '/all_users', to: 'admin#all_users'
  end

  get '*unmatched_route', to: 'pages#not_found'

  root 'pages#index'
end
