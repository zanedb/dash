# frozen_string_literal: true

Rails.application.routes.draw do
  resources :events do
    resources :attendees
  end

  get '*unmatched_route', to: 'pages#not_found'

  root 'pages#index'
end
