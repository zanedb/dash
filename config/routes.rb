# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
    delete 'users' => 'devise/registrations#destroy', :as => 'destroy_user_registration'
  end

  resources :events do
    resources :attendees
    resources :attendee_fields, path: 'fields'

    resources :organizer_position_invites, path: 'invites' do
      post 'accept'
      post 'reject'
    end
  end

  scope '/api/v1' do
    post '/events/:event_id/attendees', to: 'api#new_attendee', as: :api_new_attendee
  end

  scope '/admin' do
    get '/', to: 'admin#index', as: :admin
    get '/all_users', to: 'admin#all_users', as: :all_users
  end

  root 'pages#index'
end
