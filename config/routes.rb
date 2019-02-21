# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations invitation]
  as :user do
    get 'users/edit',
        to: 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users', to: 'devise/registrations#update', as: 'user_registration'
    delete 'users',
           to: 'devise/registrations#destroy', as: 'destroy_user_registration'
    get '/users/invitation/accept',
        to: 'devise/invitations#edit', as: :accept_user_invitation
    put '/users/invitation',
        to: 'devise/invitations#update', as: :user_invitation
    get '/users/:id', to: 'all_users#show', as: :user
    post '/users/:id/impersonate',
         to: 'all_users#impersonate', as: :impersonate_user
    post '/users/stop_impersonating',
         to: 'all_users#stop_impersonating', as: :stop_impersonating_user
  end

  resources :events do
    resources :attendees do
      collection do
        post '/:id/check_in', to: 'attendees#check_in', as: :check_in
        post '/:id/check_out', to: 'attendees#check_out', as: :check_out
        post '/:id/reset_status',
             to: 'attendees#reset_status', as: :reset_status
        get '/import', to: 'attendees#import', as: :import
        post '/import_csv', to: 'attendees#import_csv', as: :import_csv
      end
    end
    resources :attendee_fields, path: 'registration'
    resources :waivers, path: 'waiver'
    resources :attendee_waivers, path: 'waivers'

    resources :organizer_position_invites, path: 'invites' do
      post 'accept'
      post 'reject'
    end
    resources :hardwares, path: 'hardware' do
      resources :hardware_items, param: :barcode, path: 'items' do
        post 'check_out', to: 'hardware_items#check_out', as: :check_out
        post 'check_in', to: 'hardware_items#check_in', as: :check_in
      end
    end

    resources :webhooks
  end

  scope 'embed' do
    get '/:event_id', to: 'events#embed_js', as: :embed
  end

  scope '/api/v1' do
    post '/events/:event_id/attendees',
         to: 'api#new_attendee', as: :api_new_attendee
  end

  scope '/admin' do
    get '/', to: 'admin#index', as: :admin
    get '/all_users', to: 'admin#all_users', as: :all_users
  end

  root 'pages#index'
end
