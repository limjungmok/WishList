Rails.application.routes.draw do

  root                'products#new'  
  get 				  'sessions/new'

  resources :users
  resources :products
  
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
end
