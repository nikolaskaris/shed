Rails.application.routes.draw do
  
  root 'pages#home'

  devise_for :users

  resources :users, only: [:show]
  resources :gears, except: [:edit] do
    member do
      get 'listing'
      get 'pricing'
      get 'description'
      get 'photo_upload'
      get 'location'
    end
    resources :photos, only: [:create, :destroy]
    resources :reservations, only: [:create]
  end

  
  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :create]
  end

  resources :gears do
    resources :reviews, only: [:create, :destroy]
  end

  get '/preload' => 'reservations#preload'
  get '/preview' => 'reservations#preview'

  get '/your_rentals' => 'reservations#your_rentals'
  get '/your_reservations' => 'reservations#your_reservations'

  get '/search' => 'pages#search'


  # ------ Second Tutorial -------#
  get 'dashboard' => 'dashboards#index'
 
end
