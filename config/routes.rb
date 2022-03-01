Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :houses do
    resources :tribes, only: %i[new create index]
    resources :channels, only: %i[new create index]
    resources :bookings, only: %i[new create index]
  end

  resources :channels, only: :show do
    resources :messages, only: :create
  end

  resources :bookings, only: %i[show destroy]

  resources :tribes, except: %i[new create index] do
    resources :spendings, except: :show
  end
end
