# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#index'

  scope '/embed' do
    get '/:event_id', to: 'events#embed', as: :embed
  end

  scope '/api/v1' do
    post '/events/:event_id/attendees',
         to: 'api#new_attendee', as: :api_new_attendee
  end

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

  scope '/admin' do
    get '/', to: 'admin#index', as: :admin
    get '/all_users', to: 'admin#all_users', as: :all_users
  end

  get '/events', to: 'events#index', as: :events
  post '/events', to: 'events#create'
  get '/events/new', to: 'events#new', as: :new_event

  resources :events, path: '/', except: %w[index create new] do
    get '/team', to: 'events#team', as: :team
    get '/registration_config', to: 'events#registration_config', as: :registration_config
    post '/edit_registration_config', to: 'events#edit_registration_config', as: :edit_registration_config

    resources :attendees do
      collection do
        post '/:id/check_in', to: 'attendees#check_in', as: :check_in
        post '/:id/check_out', to: 'attendees#check_out', as: :check_out
        post '/:id/reset_status',
             to: 'attendees#reset_status', as: :reset_status
        get '/import', to: 'attendees#import', as: :import
        post '/import_csv', to: 'attendees#import_csv', as: :import_csv
        get '/export', to: 'attendees#export', as: :export
      end
    end
    resources :attendee_fields, path: 'registration' do
      collection do
        get '/api', to: 'attendee_fields#api', as: :api
      end
    end
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
end
