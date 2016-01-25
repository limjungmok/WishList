Rails.application.routes.draw do

  root                'static_pages#home'  
  get 'sessions/new'
  resources :users
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
end
