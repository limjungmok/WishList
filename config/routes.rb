Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root                'products#new'  
  get 				        'sessions/new'

  resources :users do
  	resources :products
      delete 'products/:id/destroy' => 'products#destroy_index', as: 'product_destroy'
  end
  
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get 'oyr_admin' => "oyr_admin#index"
  patch 'oyr_admin' => "oyr_admin#update"

  get 'guide_page' =>'users#guide'

<<<<<<< HEAD
=======
  get 'get_aj' => 'products#get_aj'

>>>>>>> 29890ad73352f7466b85bc473c71c4d45d0db07f
end
