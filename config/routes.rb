Rails.application.routes.draw do
  
  root 'pages#home'

  devise_for :users

  resources :users, only: [:show]
  resources :gears
  resources :photos

  resources :gears do
    resources :reservations, only: [:create]
  end
 
end
