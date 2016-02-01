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

  get 'get_aj' => 'products#get_aj'
  get 'get_watting_list' => 'products#get_watting_list'
end
