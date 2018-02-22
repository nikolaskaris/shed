Rails.application.routes.draw do
  
  root 'pages#home'

  devise_for :users

  resources :users, only: [:show] do
    member do
      post '/verify_phone_number' => 'users#verify_phone_number'
      patch '/update_phone_number' => 'users#update_phone_number'
    end
  end




  resources :gears, except: [:edit] do
    member do
      get 'listing'
      get 'pricing'
      get 'description'
      get 'photo_upload'
      get 'location'
      get 'preload'
      get 'preview'
    end
    resources :photos, only: [:create, :destroy]
    resources :reservations, only: [:create]
    resources :calendars
  end

  
  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :create]
  end

  resources :borrower_reviews, only: [:create, :destroy]
  resources :owner_reviews, only: [:create, :destroy]


  get '/your_rentals' => 'reservations#your_rentals'
  get '/your_bookings' => 'reservations#your_bookings'

  get 'search' => 'pages#search'

  # ----- LEVEL 2 ------- #
  get 'dashboard' => 'dashboards#index'

  resources :reservations, only: [:approve, :decline] do
    member do
      post '/approve' => "reservations#approve"
      post '/decline' => "reservations#decline"
    end
  end

  get '/owner_calendar' => "calendars#owner"
 
end
