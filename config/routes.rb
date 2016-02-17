Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root                'products#new'  
  get 				        'sessions/new'

  resources :users do
  	resources :products
  end
  
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get 'oyr_admin' => "oyr_admin#index"
  patch 'oyr_admin' => "oyr_admin#update"


  get 'get_product_count' => 'products#get_product_count'

  get 'send_email' => 'products#send_email'
  get 'send_email_for_extention' => 'products#send_email_for_extention'

  get 'get_unclassify_list' => 'products#get_unclassify_list'

  get 'extention_login' => 'products#extention_login'
  get 'extention_add' => 'products#extention_add'

  get 'findParsingAction' => 'parsing#findParsingAction'
  get 'get_product_last_product' => 'products#get_product_last_product'

  get 'get_product_last_product_for_extention' => 'products#get_product_last_product_for_extention'

end 
