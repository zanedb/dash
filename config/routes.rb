# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit', to: 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users', to: 'devise/registrations#update', as: 'user_registration'
    delete 'users', to: 'devise/registrations#destroy', as: 'destroy_user_registration'
  end

  resources :events do
    resources :attendees do
      collection do
        post '/:id/check_in', to: 'attendees#check_in', as: :check_in
        post '/:id/check_out', to: 'attendees#check_out', as: :check_out
        get '/import', to: 'attendees#import', as: :import
        post '/import_csv', to: 'attendees#import_csv', as: :import_csv
      end
    end
    resources :attendee_fields, path: 'fields'

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
