Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :houses, except: :index do
    resources :tribes, only: %i[new create index]
    resources :channels, only: %i[new create index]
    resources :bookings, only: %i[new index]
    post '/bookings/', to: 'bookings#create', as: :create_booking
  end

  get '/houses/:id/calendar', to: 'houses#calendar', as: :calendar

  resources :channels, only: :show do
    resources :messages, only: :create
  end

  resources :bookings, only: %i[show edit update]
  delete '/bookings/:id', to: 'bookings#destroy', as: :delete_booking

  resources :tribes, except: %i[new create index] do
    resources :spendings, except: :show
  end
end
